/*
  Warnings:

  - You are about to drop the `Report` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Report" DROP CONSTRAINT "Report_userId_fkey";

-- DropTable
DROP TABLE "Report";

-- DropEnum
DROP TYPE "FUELTYPE";

-- DropEnum
DROP TYPE "TRANSMISSION";
