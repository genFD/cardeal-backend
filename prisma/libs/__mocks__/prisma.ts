//1 - 👇🏽 Imports all of the tools needed to create the mocked client.

import { PrismaClient } from '@prisma/client';

import { beforeEach } from 'vitest';

import { mockDeep, mockReset } from 'vitest-mock-extended';

// 2 - 👇🏽 Lets Vitest know that between each individual test the mock should be reset to its original state.

beforeEach(() => {
  mockReset(prisma);
});

// 3 - 👇🏽 Creates and exports a "deep mock" of Prisma Client using the vitest-mock-extended library's mockDeep function which ensures all properties of the object, even deeply nested ones, are mocked.

const prisma = mockDeep<PrismaClient>();

export default prisma;
