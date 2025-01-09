/*
  Warnings:

  - You are about to drop the `Bet` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_BetToUser` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "_BetToUser" DROP CONSTRAINT "_BetToUser_A_fkey";

-- DropForeignKey
ALTER TABLE "_BetToUser" DROP CONSTRAINT "_BetToUser_B_fkey";

-- DropTable
DROP TABLE "Bet";

-- DropTable
DROP TABLE "_BetToUser";

-- CreateTable
CREATE TABLE "Game" (
    "id" TEXT NOT NULL,
    "game_prms" TEXT NOT NULL,
    "game_msgs" TEXT NOT NULL,

    CONSTRAINT "Game_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_GameToUser" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Game_id_key" ON "Game"("id");

-- CreateIndex
CREATE UNIQUE INDEX "_GameToUser_AB_unique" ON "_GameToUser"("A", "B");

-- CreateIndex
CREATE INDEX "_GameToUser_B_index" ON "_GameToUser"("B");

-- AddForeignKey
ALTER TABLE "_GameToUser" ADD CONSTRAINT "_GameToUser_A_fkey" FOREIGN KEY ("A") REFERENCES "Game"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_GameToUser" ADD CONSTRAINT "_GameToUser_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
