// prisma.config.ts
import "dotenv/config";              // loads .env by default; can be overridden with DOTENV_CONFIG_PATH
import { defineConfig } from "prisma/config";

export default defineConfig({
  schema: "prisma/schema.prisma",
});
