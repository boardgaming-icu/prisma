/*
  Warnings:

  - The primary key for the `Auth` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `token` on the `Auth` table. All the data in the column will be lost.
  - You are about to drop the column `password` on the `User` table. All the data in the column will be lost.
  - Added the required column `password` to the `Auth` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `type` on the `Transaction` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('CREDIT', 'DEBIT', 'GIFT', 'TRANSFER');

-- DropForeignKey
ALTER TABLE "Connection" DROP CONSTRAINT "Connection_user_id_fkey";

-- DropIndex
DROP INDEX "Auth_user_id_key";

-- AlterTable
ALTER TABLE "Auth" DROP CONSTRAINT "Auth_pkey",
DROP COLUMN "token",
ADD COLUMN     "password" TEXT NOT NULL,
ADD CONSTRAINT "Auth_pkey" PRIMARY KEY ("user_id");

-- AlterTable
ALTER TABLE "Connection" ADD COLUMN     "linked_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "Transaction" ADD COLUMN     "transferredFrom" TEXT,
DROP COLUMN "type",
ADD COLUMN     "type" "TransactionType" NOT NULL;

-- AlterTable
ALTER TABLE "User" DROP COLUMN "password";

-- CreateTable
CREATE TABLE "AuthToken" (
    "user_id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "ip_sha" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "lastUsed" TIMESTAMP(3),

    CONSTRAINT "AuthToken_pkey" PRIMARY KEY ("user_id","token")
);

-- CreateIndex
CREATE INDEX "Connection_platform_id_idx" ON "Connection"("platform_id");

-- AddForeignKey
ALTER TABLE "Connection" ADD CONSTRAINT "Connection_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuthToken" ADD CONSTRAINT "AuthToken_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "Auth"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Wallet" ADD CONSTRAINT "Wallet_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
