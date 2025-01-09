-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "avatar" TEXT NOT NULL DEFAULT 'default.png',
    "auth_token" TEXT NOT NULL,
    "balance" DOUBLE PRECISION NOT NULL DEFAULT 1500,
    "notif_message" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bet" (
    "bet_id" TEXT NOT NULL,
    "options" JSONB NOT NULL,

    CONSTRAINT "Bet_pkey" PRIMARY KEY ("bet_id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "head" TEXT NOT NULL,
    "body" TEXT NOT NULL,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_BetToUser" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User_id_key" ON "User"("id");

-- CreateIndex
CREATE UNIQUE INDEX "User_auth_token_key" ON "User"("auth_token");

-- CreateIndex
CREATE UNIQUE INDEX "Bet_bet_id_key" ON "Bet"("bet_id");

-- CreateIndex
CREATE UNIQUE INDEX "Notification_id_key" ON "Notification"("id");

-- CreateIndex
CREATE UNIQUE INDEX "_BetToUser_AB_unique" ON "_BetToUser"("A", "B");

-- CreateIndex
CREATE INDEX "_BetToUser_B_index" ON "_BetToUser"("B");

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BetToUser" ADD CONSTRAINT "_BetToUser_A_fkey" FOREIGN KEY ("A") REFERENCES "Bet"("bet_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BetToUser" ADD CONSTRAINT "_BetToUser_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
