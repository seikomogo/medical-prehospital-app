-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('POMPIER', 'AMBULANTIER', 'ASISTENT', 'MEDIC');

-- CreateEnum
CREATE TYPE "VerificationCodeType" AS ENUM ('EMAIL_VERIFICATION', 'PASSWORD_RESET');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password_Hash" TEXT NOT NULL,
    "role" "UserRole" NOT NULL,
    "institution" TEXT NOT NULL,
    "region" TEXT NOT NULL,
    "is_Verified" BOOLEAN NOT NULL DEFAULT false,
    "is_Active" BOOLEAN NOT NULL DEFAULT true,
    "last_Login" TIMESTAMP(3),
    "created_At" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_At" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "verification_Codes" (
    "id" TEXT NOT NULL,
    "user_Id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "type" "VerificationCodeType" NOT NULL,
    "used" BOOLEAN NOT NULL DEFAULT false,
    "expires_At" TIMESTAMP(3) NOT NULL,
    "created_At" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "verification_Codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_Tokens" (
    "id" TEXT NOT NULL,
    "user_Id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "created_At" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_At" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "refresh_Tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "emergency_indices" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "description" TEXT,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "is_Active" BOOLEAN NOT NULL DEFAULT true,
    "created_At" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_At" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "emergency_indices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "questions" (
    "id" TEXT NOT NULL,
    "emergency_Index_Id" TEXT NOT NULL,
    "question_Text" TEXT NOT NULL,
    "question_Order" INTEGER NOT NULL,
    "is_Critical" BOOLEAN NOT NULL DEFAULT false,
    "created_At" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "anamnesis_Records" (
    "id" TEXT NOT NULL,
    "user_Id" TEXT NOT NULL,
    "emergency_Index_Id" TEXT NOT NULL,
    "answers" JSONB NOT NULL,
    "generated_Text" TEXT NOT NULL,
    "generation_Method" TEXT,
    "created_At" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "anamnesis_Records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_Logs" (
    "id" TEXT NOT NULL,
    "user_Id" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "ip_Address" TEXT,
    "user_Agent" TEXT,
    "details" JSONB,
    "created_At" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_Logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "verification_Codes_user_Id_idx" ON "verification_Codes"("user_Id");

-- CreateIndex
CREATE INDEX "verification_Codes_code_type_used_expires_At_idx" ON "verification_Codes"("code", "type", "used", "expires_At");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_Tokens_token_key" ON "refresh_Tokens"("token");

-- CreateIndex
CREATE INDEX "refresh_Tokens_user_Id_idx" ON "refresh_Tokens"("user_Id");

-- CreateIndex
CREATE INDEX "refresh_Tokens_token_idx" ON "refresh_Tokens"("token");

-- CreateIndex
CREATE UNIQUE INDEX "emergency_indices_code_key" ON "emergency_indices"("code");

-- CreateIndex
CREATE INDEX "questions_emergency_Index_Id_idx" ON "questions"("emergency_Index_Id");

-- CreateIndex
CREATE INDEX "anamnesis_Records_user_Id_idx" ON "anamnesis_Records"("user_Id");

-- CreateIndex
CREATE INDEX "anamnesis_Records_emergency_Index_Id_idx" ON "anamnesis_Records"("emergency_Index_Id");

-- CreateIndex
CREATE INDEX "audit_Logs_user_Id_idx" ON "audit_Logs"("user_Id");

-- CreateIndex
CREATE INDEX "audit_Logs_action_idx" ON "audit_Logs"("action");

-- AddForeignKey
ALTER TABLE "verification_Codes" ADD CONSTRAINT "verification_Codes_user_Id_fkey" FOREIGN KEY ("user_Id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refresh_Tokens" ADD CONSTRAINT "refresh_Tokens_user_Id_fkey" FOREIGN KEY ("user_Id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "questions" ADD CONSTRAINT "questions_emergency_Index_Id_fkey" FOREIGN KEY ("emergency_Index_Id") REFERENCES "emergency_indices"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "anamnesis_Records" ADD CONSTRAINT "anamnesis_Records_user_Id_fkey" FOREIGN KEY ("user_Id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "anamnesis_Records" ADD CONSTRAINT "anamnesis_Records_emergency_Index_Id_fkey" FOREIGN KEY ("emergency_Index_Id") REFERENCES "emergency_indices"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_Logs" ADD CONSTRAINT "audit_Logs_user_Id_fkey" FOREIGN KEY ("user_Id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
