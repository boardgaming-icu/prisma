/*
  Warnings:

  - Added the required column `moderator` to the `Punishment` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Punishment" ADD COLUMN     "moderator" TEXT NOT NULL;
