/*
  Warnings:

  - The primary key for the `Connection` table will be changed. If it partially fails, the table could be left without primary key constraint.

*/
-- AlterTable
ALTER TABLE "Connection" DROP CONSTRAINT "Connection_pkey",
ADD CONSTRAINT "Connection_pkey" PRIMARY KEY ("platform", "platform_id");
