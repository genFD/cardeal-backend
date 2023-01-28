import { PrismaClient } from '@prisma/client';
import { reportData, userData } from './data';

const prisma = new PrismaClient();

async function main() {
  try {
    await prisma.user.createMany(userData);
    // const reports = await prisma.report.createMany(reports);
  } catch (error) {
    console.log(error);
  }
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
