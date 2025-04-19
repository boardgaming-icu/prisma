/*
  Warnings:

  - A unique constraint covering the columns `[verification]` on the table `User` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "User" ALTER COLUMN "auth_token" DROP NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "User_verification_key" ON "User"("verification");
