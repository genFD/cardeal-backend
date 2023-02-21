/*
  Warnings:

  - Changed the type of `transmission` on the `Report` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `fuel_type` on the `Report` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "Report" DROP COLUMN "transmission",
ADD COLUMN     "transmission" TEXT NOT NULL,
DROP COLUMN "fuel_type",
ADD COLUMN     "fuel_type" TEXT NOT NULL;

-- DropEnum
DROP TYPE "FUELTYPE";

-- DropEnum
DROP TYPE "TRANSMISSION";
