/*
  Warnings:

  - You are about to drop the column `last_spin` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `notif_message` on the `User` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[email]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Changed the type of `game_prms` on the `Game` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `game_msgs` on the `Game` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Added the required column `email` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `verification` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "PunishmentType" AS ENUM ('DISCORD', 'GAME');

-- AlterTable
ALTER TABLE "Game" DROP COLUMN "game_prms",
ADD COLUMN     "game_prms" JSONB NOT NULL,
DROP COLUMN "game_msgs",
ADD COLUMN     "game_msgs" JSONB NOT NULL;

-- AlterTable
ALTER TABLE "Notification" ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "readAt" TIMESTAMP(3);

-- AlterTable
ALTER TABLE "User" DROP COLUMN "last_spin",
DROP COLUMN "notif_message",
ADD COLUMN     "auth_expires" TEXT,
ADD COLUMN     "badges" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "email" TEXT NOT NULL,
ADD COLUMN     "last_claim" TIMESTAMP(3),
ADD COLUMN     "last_login" TIMESTAMP(3),
ADD COLUMN     "settings" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "verification" TEXT NOT NULL,
ALTER COLUMN "balance" SET DEFAULT 100;

-- CreateTable
CREATE TABLE "Punishment" (
    "id" TEXT NOT NULL,
    "type" "PunishmentType" NOT NULL,
    "punishment" TEXT NOT NULL,
    "account_id" TEXT,
    "discord_id" TEXT,
    "reason" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,
    "applied" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Punishment_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Punishment_id_key" ON "Punishment"("id");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- AddForeignKey
ALTER TABLE "Punishment" ADD CONSTRAINT "Punishment_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
