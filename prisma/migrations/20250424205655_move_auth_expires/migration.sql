/*
  Warnings:

  - You are about to drop the column `auth_expires` on the `Auth` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Auth" DROP COLUMN "auth_expires";

-- AlterTable
ALTER TABLE "AuthToken" ADD COLUMN     "expires" TIMESTAMP(3);
