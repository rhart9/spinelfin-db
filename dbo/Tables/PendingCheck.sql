CREATE TABLE [dbo].[PendingCheck] (
    [PendingCheckID]      INT             IDENTITY (1, 1) NOT NULL,
    [CheckNumber]         NVARCHAR (10)   NOT NULL,
    [CheckDate]           DATE            NOT NULL,
    [Payee]               NVARCHAR (1024) NOT NULL,
    [FriendlyDescription] NVARCHAR (1024) NULL
);
GO

ALTER TABLE [dbo].[PendingCheck]
    ADD CONSTRAINT [PK_PendingCheck] PRIMARY KEY CLUSTERED ([PendingCheckID] ASC);
GO

