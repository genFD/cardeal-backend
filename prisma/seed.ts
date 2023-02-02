import { PrismaClient } from '@prisma/client';
import { userData } from './data';

const prisma = new PrismaClient();

async function main() {
  try {
    await prisma.user.createMany(userData);
  } catch (e) {
    console.log(e);
  }
}
main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.log(e);
    await prisma.$disconnect();
    process.exit(1);
  });
