/*
  Warnings:

  - You are about to drop the column `approved` on the `Report` table. All the data in the column will be lost.
  - You are about to drop the column `authorId` on the `Report` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Report" DROP CONSTRAINT "Report_authorId_fkey";

-- AlterTable
ALTER TABLE "Report" DROP COLUMN "approved",
DROP COLUMN "authorId";
