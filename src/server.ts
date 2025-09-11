import Fastify from "fastify";
import contactsRoutes from "./routes/contacts";

const app = Fastify({ logger: true });

// Log the admin token once so you can verify it matches your client
console.log("ADMIN_TOKEN (server):", JSON.stringify(process.env.ADMIN_TOKEN));

// Health
app.get("/healthz", async () => ({ ok: true }));

// Versioned API
app.register(contactsRoutes, { prefix: "/api/v1" });

// Backward compatibility: keep old /contacts working for now
app.all("/contacts", async (req, reply) => {
  // Proxy to the versioned route, preserving method and body
  const url = "/api/v1/contacts";
  // For GET just forward
  if (req.method === "GET") return reply.redirect(308, url);
  // For POST call the handler by injecting a request to the prefixed route
  // Simple redirect also works for most clients
  return reply.redirect(308, url);
});

// Print mounted routes once everything is ready
app.ready().then(() => app.printRoutes());

const port = Number(process.env.PORT ?? 7001);
app.listen({ port, host: "0.0.0.0" })
  .then(() => console.log(`API listening on :${port}`))
  .catch(err => { app.log.error(err); process.exit(1); });
