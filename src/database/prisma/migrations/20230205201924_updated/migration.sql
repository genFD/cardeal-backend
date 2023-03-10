/*
  Warnings:

  - Added the required column `color` to the `Report` table without a default value. This is not possible if the table is not empty.
  - Added the required column `fuel_type` to the `Report` table without a default value. This is not possible if the table is not empty.
  - Added the required column `transmission` to the `Report` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "TRANSMISSION" AS ENUM ('MANUAL', 'AUTOMATIC');

-- CreateEnum
CREATE TYPE "FUELTYPE" AS ENUM ('GASOLINE', 'HYBRID', 'ELECTRIC');

-- AlterTable
ALTER TABLE "Report" ADD COLUMN     "color" TEXT NOT NULL,
ADD COLUMN     "fuel_type" "FUELTYPE" NOT NULL,
ADD COLUMN     "transmission" "TRANSMISSION" NOT NULL,
ALTER COLUMN "longitude" DROP NOT NULL,
ALTER COLUMN "latitude" DROP NOT NULL;
