import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
    console.log('Starting database seeding...');

    // clear existing data (development only!)
    if (process.env.NODE_ENV === 'development') {
        console.log('Clearing existing data...');
        await prisma.anamnesisRecord.deleteMany();
        await prisma.question.deleteMany();
        await prisma.emergencyIndex.deleteMany();
        await prisma.refreshToken.deleteMany();
        await prisma.auditLog.deleteMany();
        await prisma.user.deleteMany();
}

// seed test user (development only!)
    if (process.env.NODE_END === 'development') {
        const testPassword = await bcrypt.hash('TestPassword123!', 12);

        const testUser = await prisma.user.create({
            data: {
                email: '[email protected]',
                passwordHash: testPassword,
                role:'MEDIC',
                institution: 'Test Hospital',
                region: 'Bucharest',
                isVerified: true,
            },
        });

        console.log('Created test user:', testUser.email);
    }
    
    // seed emergency indices
    const emergencyIndices = [
        {
            name:  'Dureri Toracice',
            code: 'CHEST_PAIN',
            description: 'Dureri in regiunea toracica, posibil de origine cardiaca.',
            priority: 1,
        },
        {
            name: 'Accident Auto',
            code: 'AUTO_ACCIDENT',
            description: 'Coliziune vehicule cu potentiale victime',
            priority: 1,
        },
        {
            name: 'Sincopa',
            code: 'SYNCOPE',
            description: 'Pierdere brusca si tranzitorie a constientei',
            priority: 2,
        },
        {
            name: 'Dispnee',
            code: 'DYSPNEA',
            description: 'Dificultate in respiratie sau lipsa de aer',
            priority: 2,
        },

        // Add other emergency indices as needed
    ];

    for (const indexData of emergencyIndices) {
        const emergencyIndex = await prisma.emergencyIndex.create({
            data: indexData,
        });

        console.log('Created emergency index: ${emergencyIndex.name}');

        // Seed questions for each index
        if (emergencyIndex.code === 'CHEST_PAIN') {
            const questions = [
                {
                    questionText: "Pacientul este constient?",
                    questionOrder: 1,
                    isCritical:true,
                },
                {
                    questionText: "Pacientul prezinta durere toracica?",
                    questionOrder: 2,
                    isCritical:true,
                },
                {
                    questionText: "Durerea iradiaza catre brat, maxilar sau spate?",
                    questionOrder: 3,
                    isCritical:true,
                },
                {
                    questionText: "Pacientul este transpirat?",
                    questionOrder: 4,
                    isCritical:true,
                },
                {
                    questionText: "Pacientul prezinta greata sau varsaturi?",
                    questionOrder: 5,
                    isCritical:true,
                },
                {
                    questionText: "Pacientul are antecedente de boli cardiace?",
                    questionOrder: 6,
                    isCritical:false,
                },
            ];

            for (const questionData of questions) {
                await prisma.question.create({
                    data: {
                        ...questionData,
                        emergencyIndexId: emergencyIndex.id,
                    },
                });
            }

            console.log('Added ${questions.length} questions');
        }

        // add questions for other indices similarly
    }

    console.log('Seeding completed succesfully!');
}

main()
    .catch((e) => {
        console.error('Seeding error:', e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });