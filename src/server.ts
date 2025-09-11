import Fastify from 'fastify'
import cors from '@fastify/cors'
import { PrismaClient } from '@prisma/client'
import * as dotenv from 'dotenv'
import { z } from 'zod'

dotenv.config()

const app = Fastify({ logger: true })
await app.register(cors, { origin: true })

const prisma = new PrismaClient()

const PORT = Number(process.env.PORT || 7001)
const ADMIN_TOKEN = process.env.ADMIN_TOKEN || ''

app.get('/health', async () => {
  return { ok: true, env: process.env.BHQ_ENV || 'dev' }
})

app.get('/contacts', async () => {
  const contacts = await prisma.contact.findMany({
    orderBy: [{ createdAt: 'desc' }],
    take: 100,
  })
  return contacts
})

const NewContact = z.object({
  firstName: z.string().min(1),
  lastName: z.string().min(1),
  email: z.string().email().optional(),
  phone: z.string().optional(),
})

app.post('/contacts', async (req, reply) => {
  const token = req.headers['x-admin-token']
  if (!ADMIN_TOKEN || token !== ADMIN_TOKEN) {
    return reply.code(401).send({ error: 'unauthorized' })
  }

  const parse = NewContact.safeParse(req.body)
  if (!parse.success) {
    return reply.code(400).send({ error: 'invalid_payload', details: parse.error.flatten() })
  }

  const c = await prisma.contact.create({ data: parse.data })
  return reply.code(201).send(c)
})

try {
  await app.listen({ host: '0.0.0.0', port: PORT })
  console.log(`API listening on :${PORT}`)
} catch (err) {
  app.log.error(err)
  process.exit(1)
}
