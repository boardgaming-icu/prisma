/*
  Warnings:

  - You are about to drop the column `created_at` on the `Notification` table. All the data in the column will be lost.
  - You are about to drop the column `read` on the `Notification` table. All the data in the column will be lost.
  - You are about to drop the column `readAt` on the `Notification` table. All the data in the column will be lost.
  - You are about to drop the column `user_id` on the `Transaction` table. All the data in the column will be lost.
  - The primary key for the `Wallet` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the `_NotificationToUser` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `wallet_id` to the `Transaction` table without a default value. This is not possible if the table is not empty.
  - Added the required column `wallet_id` to the `Wallet` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Transaction" DROP CONSTRAINT "Transaction_user_id_fkey";

-- DropForeignKey
ALTER TABLE "UserPermission" DROP CONSTRAINT "UserPermission_permission_id_fkey";

-- DropForeignKey
ALTER TABLE "UserPermission" DROP CONSTRAINT "UserPermission_user_id_fkey";

-- DropForeignKey
ALTER TABLE "UserSetting" DROP CONSTRAINT "UserSetting_setting_id_fkey";

-- DropForeignKey
ALTER TABLE "UserSetting" DROP CONSTRAINT "UserSetting_user_id_fkey";

-- DropForeignKey
ALTER TABLE "_NotificationToUser" DROP CONSTRAINT "_NotificationToUser_A_fkey";

-- DropForeignKey
ALTER TABLE "_NotificationToUser" DROP CONSTRAINT "_NotificationToUser_B_fkey";

-- DropIndex
DROP INDEX "Transaction_user_id_idx";

-- AlterTable
ALTER TABLE "Notification" DROP COLUMN "created_at",
DROP COLUMN "read",
DROP COLUMN "readAt";

-- AlterTable
ALTER TABLE "Transaction" DROP COLUMN "user_id",
ADD COLUMN     "wallet_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Wallet" DROP CONSTRAINT "Wallet_pkey",
ADD COLUMN     "tournament_id" TEXT,
ADD COLUMN     "wallet_id" TEXT NOT NULL,
ADD CONSTRAINT "Wallet_pkey" PRIMARY KEY ("wallet_id");

-- DropTable
DROP TABLE "_NotificationToUser";

-- CreateTable
CREATE TABLE "UserNotification" (
    "user_id" TEXT NOT NULL,
    "noti_id" TEXT NOT NULL,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "readAt" TIMESTAMP(3),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserNotification_pkey" PRIMARY KEY ("user_id","noti_id")
);

-- CreateIndex
CREATE INDEX "Transaction_wallet_id_idx" ON "Transaction"("wallet_id");

-- AddForeignKey
ALTER TABLE "UserPermission" ADD CONSTRAINT "UserPermission_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPermission" ADD CONSTRAINT "UserPermission_permission_id_fkey" FOREIGN KEY ("permission_id") REFERENCES "Permission"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserSetting" ADD CONSTRAINT "UserSetting_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserSetting" ADD CONSTRAINT "UserSetting_setting_id_fkey" FOREIGN KEY ("setting_id") REFERENCES "Setting"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserNotification" ADD CONSTRAINT "UserNotification_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserNotification" ADD CONSTRAINT "UserNotification_noti_id_fkey" FOREIGN KEY ("noti_id") REFERENCES "Notification"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_wallet_id_fkey" FOREIGN KEY ("wallet_id") REFERENCES "Wallet"("wallet_id") ON DELETE RESTRICT ON UPDATE CASCADE;
