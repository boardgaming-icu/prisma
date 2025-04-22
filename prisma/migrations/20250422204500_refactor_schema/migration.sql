/*
  Warnings:

  - You are about to drop the column `game_msgs` on the `Game` table. All the data in the column will be lost.
  - You are about to drop the column `game_prms` on the `Game` table. All the data in the column will be lost.
  - You are about to drop the column `auth_expires` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `auth_token` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `badges` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `balance` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `disc_id` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `last_login` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `settings` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `verified` on the `User` table. All the data in the column will be lost.
  - The `status` column on the `User` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the `_GameToUser` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `created_by` to the `Game` table without a default value. This is not possible if the table is not empty.
  - Added the required column `game_name` to the `Game` table without a default value. This is not possible if the table is not empty.
  - Added the required column `table_name` to the `Game` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('REPORTED', 'ACTIVE', 'UNVERIFIED', 'PUNISHMENT', 'NOPFP', 'NOCHAT', 'NONAMECHANGE');

-- CreateEnum
CREATE TYPE "TransactionStatus" AS ENUM ('FAILED', 'COMPLETE', 'PENDING', 'OTHER');

-- DropForeignKey
ALTER TABLE "_GameToUser" DROP CONSTRAINT "_GameToUser_A_fkey";

-- DropForeignKey
ALTER TABLE "_GameToUser" DROP CONSTRAINT "_GameToUser_B_fkey";

-- DropIndex
DROP INDEX "Game_id_key";

-- DropIndex
DROP INDEX "User_auth_token_key";

-- DropIndex
DROP INDEX "User_disc_id_key";

-- AlterTable
ALTER TABLE "Game" DROP COLUMN "game_msgs",
DROP COLUMN "game_prms",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "created_by" TEXT NOT NULL,
ADD COLUMN     "ended_at" TIMESTAMP(3),
ADD COLUMN     "game_name" TEXT NOT NULL,
ADD COLUMN     "table_name" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "User" DROP COLUMN "auth_expires",
DROP COLUMN "auth_token",
DROP COLUMN "badges",
DROP COLUMN "balance",
DROP COLUMN "disc_id",
DROP COLUMN "last_login",
DROP COLUMN "settings",
DROP COLUMN "verified",
DROP COLUMN "status",
ADD COLUMN     "status" "UserStatus"[] DEFAULT ARRAY['UNVERIFIED']::"UserStatus"[];

-- DropTable
DROP TABLE "_GameToUser";

-- CreateTable
CREATE TABLE "Permission" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "Permission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserPermission" (
    "user_id" TEXT NOT NULL,
    "permission_id" TEXT NOT NULL,

    CONSTRAINT "UserPermission_pkey" PRIMARY KEY ("user_id","permission_id")
);

-- CreateTable
CREATE TABLE "Setting" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "type" TEXT NOT NULL,

    CONSTRAINT "Setting_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserSetting" (
    "user_id" TEXT NOT NULL,
    "setting_id" TEXT NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "UserSetting_pkey" PRIMARY KEY ("user_id","setting_id")
);

-- CreateTable
CREATE TABLE "Badge" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "Badge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Connection" (
    "user_id" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "platform_id" TEXT NOT NULL,

    CONSTRAINT "Connection_pkey" PRIMARY KEY ("user_id","platform")
);

-- CreateTable
CREATE TABLE "Auth" (
    "token" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "auth_expires" TIMESTAMP(3),
    "last_login" TIMESTAMP(3),
    "totp_key" TEXT,

    CONSTRAINT "Auth_pkey" PRIMARY KEY ("token")
);

-- CreateTable
CREATE TABLE "Round" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "end_time" TIMESTAMP(3),
    "outcome" TEXT NOT NULL,
    "payload" JSONB NOT NULL,

    CONSTRAINT "Round_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RoundPlayer" (
    "round_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "seat" INTEGER NOT NULL,
    "hand" JSONB NOT NULL,
    "bet" BIGINT,
    "return" BIGINT,
    "is_winner" BOOLEAN NOT NULL DEFAULT false,
    "joined_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RoundPlayer_pkey" PRIMARY KEY ("round_id","user_id")
);

-- CreateTable
CREATE TABLE "RoundEvent" (
    "id" TEXT NOT NULL,
    "roundId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "initiator" TEXT,
    "target" TEXT,
    "outcome" BOOLEAN NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RoundEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Wallet" (
    "user_id" TEXT NOT NULL,
    "balance" BIGINT NOT NULL DEFAULT 10000,

    CONSTRAINT "Wallet_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "Transaction" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "amount" BIGINT NOT NULL,
    "type" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "reference_id" TEXT NOT NULL,
    "status" "TransactionStatus" NOT NULL,

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_UserBadges" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_UserBadges_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "Permission_id_key" ON "Permission"("id");

-- CreateIndex
CREATE UNIQUE INDEX "Setting_id_key" ON "Setting"("id");

-- CreateIndex
CREATE UNIQUE INDEX "Badge_id_key" ON "Badge"("id");

-- CreateIndex
CREATE UNIQUE INDEX "Auth_user_id_key" ON "Auth"("user_id");

-- CreateIndex
CREATE INDEX "Round_start_time_idx" ON "Round"("start_time");

-- CreateIndex
CREATE INDEX "Round_end_time_idx" ON "Round"("end_time");

-- CreateIndex
CREATE INDEX "RoundEvent_roundId_idx" ON "RoundEvent"("roundId");

-- CreateIndex
CREATE INDEX "RoundEvent_type_idx" ON "RoundEvent"("type");

-- CreateIndex
CREATE INDEX "RoundEvent_timestamp_idx" ON "RoundEvent"("timestamp");

-- CreateIndex
CREATE INDEX "RoundEvent_outcome_idx" ON "RoundEvent"("outcome");

-- CreateIndex
CREATE UNIQUE INDEX "Transaction_reference_id_key" ON "Transaction"("reference_id");

-- CreateIndex
CREATE INDEX "Transaction_user_id_idx" ON "Transaction"("user_id");

-- CreateIndex
CREATE INDEX "Transaction_created_at_idx" ON "Transaction"("created_at");

-- CreateIndex
CREATE INDEX "Transaction_reference_id_idx" ON "Transaction"("reference_id");

-- CreateIndex
CREATE INDEX "_UserBadges_B_index" ON "_UserBadges"("B");

-- CreateIndex
CREATE INDEX "Game_created_at_idx" ON "Game"("created_at");

-- CreateIndex
CREATE INDEX "Game_ended_at_idx" ON "Game"("ended_at");

-- AddForeignKey
ALTER TABLE "UserPermission" ADD CONSTRAINT "UserPermission_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPermission" ADD CONSTRAINT "UserPermission_permission_id_fkey" FOREIGN KEY ("permission_id") REFERENCES "Permission"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserSetting" ADD CONSTRAINT "UserSetting_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserSetting" ADD CONSTRAINT "UserSetting_setting_id_fkey" FOREIGN KEY ("setting_id") REFERENCES "Setting"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Connection" ADD CONSTRAINT "Connection_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Auth" ADD CONSTRAINT "Auth_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Round" ADD CONSTRAINT "Round_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "Game"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RoundPlayer" ADD CONSTRAINT "RoundPlayer_round_id_fkey" FOREIGN KEY ("round_id") REFERENCES "Round"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RoundPlayer" ADD CONSTRAINT "RoundPlayer_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RoundEvent" ADD CONSTRAINT "RoundEvent_roundId_fkey" FOREIGN KEY ("roundId") REFERENCES "Round"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "Wallet"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserBadges" ADD CONSTRAINT "_UserBadges_A_fkey" FOREIGN KEY ("A") REFERENCES "Badge"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserBadges" ADD CONSTRAINT "_UserBadges_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
