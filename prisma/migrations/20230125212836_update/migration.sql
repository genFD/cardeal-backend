/*
  Warnings:

  - You are about to drop the column `latitude` on the `Report` table. All the data in the column will be lost.
  - You are about to drop the column `longitude` on the `Report` table. All the data in the column will be lost.
  - Added the required column `color` to the `Report` table without a default value. This is not possible if the table is not empty.
  - Added the required column `fuel_type` to the `Report` table without a default value. This is not possible if the table is not empty.
  - Added the required column `transmission` to the `Report` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `price` on the `Report` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "FUELTYPE" AS ENUM ('GASOLINE', 'DIESEL', 'HYBRID', 'ELECTRIC');

-- CreateEnum
CREATE TYPE "TRANSMISSION" AS ENUM ('AUTOMATIC', 'MANUAL');

-- AlterTable
ALTER TABLE "Report" DROP COLUMN "latitude",
DROP COLUMN "longitude",
ADD COLUMN     "color" TEXT NOT NULL,
ADD COLUMN     "fuel_type" "FUELTYPE" NOT NULL,
ADD COLUMN     "transmission" "TRANSMISSION" NOT NULL,
DROP COLUMN "price",
ADD COLUMN     "price" MONEY NOT NULL;
