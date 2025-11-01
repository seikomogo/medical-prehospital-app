import { PrismaClient } from '@prisma/client';

// extend global namespace for development hot reload
declare global {
  // eslint-disable-next-line no-var
  var prisma: PrismaClient | undefined;
}

// create Prisma client instance
const prismaClient = global.prisma || new PrismaClient({
    log: process.env.NODE_ENV === 'development'
    ? ['query', 'error', 'warn']
    : ['error'],
});

// in development, store in global to prevent multiple instances during hot reload
if (process.env.NODE_ENV === 'development') {
    global.prisma = prismaClient;
}

// graceful shutdown
process.on('beforeExit', async () => {
    await prismaClient.$disconnect();
});

export const prisma = prismaClient;