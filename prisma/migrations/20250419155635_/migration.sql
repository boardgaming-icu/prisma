/*
  Warnings:

  - The primary key for the `Punishment` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Punishment` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "Punishment" DROP CONSTRAINT "Punishment_pkey",
ADD COLUMN     "current" BOOLEAN NOT NULL DEFAULT true,
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ALTER COLUMN "expires" DROP NOT NULL,
ADD CONSTRAINT "Punishment_pkey" PRIMARY KEY ("id");

-- CreateIndex
CREATE UNIQUE INDEX "Punishment_id_key" ON "Punishment"("id");
