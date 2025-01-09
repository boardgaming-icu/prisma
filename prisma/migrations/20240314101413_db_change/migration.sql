/*
  Warnings:

  - The `notif_message` column on the `User` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "User" ADD COLUMN     "disc_id" TEXT,
ADD COLUMN     "password" TEXT,
ADD COLUMN     "status" INTEGER NOT NULL DEFAULT 0,
DROP COLUMN "notif_message",
ADD COLUMN     "notif_message" INTEGER NOT NULL DEFAULT 0;
