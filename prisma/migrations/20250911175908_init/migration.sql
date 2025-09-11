-- CreateEnum
CREATE TYPE "DepositStatus" AS ENUM ('PENDING', 'COMMITTED', 'REFUNDED');

-- CreateTable
CREATE TABLE "Contact" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT,

    CONSTRAINT "Contact_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Organization" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "website" TEXT,

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationOnContact" (
    "contactId" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "role" TEXT,

    CONSTRAINT "OrganizationOnContact_pkey" PRIMARY KEY ("contactId","organizationId")
);

-- CreateTable
CREATE TABLE "Deposit" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "amountCents" INTEGER NOT NULL,
    "status" "DepositStatus" NOT NULL DEFAULT 'PENDING',
    "contactId" TEXT NOT NULL,
    "organizationId" TEXT,

    CONSTRAINT "Deposit_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Contact_email_key" ON "Contact"("email");

-- AddForeignKey
ALTER TABLE "OrganizationOnContact" ADD CONSTRAINT "OrganizationOnContact_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES "Contact"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationOnContact" ADD CONSTRAINT "OrganizationOnContact_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Deposit" ADD CONSTRAINT "Deposit_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES "Contact"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Deposit" ADD CONSTRAINT "Deposit_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;
