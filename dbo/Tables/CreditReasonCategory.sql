CREATE TABLE [dbo].[CreditReasonCategory] (
    [CreditReasonCategoryID] INT            IDENTITY (1, 1) NOT NULL,
    [CategoryDescription]    NVARCHAR (256) NOT NULL
);
GO

ALTER TABLE [dbo].[CreditReasonCategory]
    ADD CONSTRAINT [PK_CreditReasonCategory] PRIMARY KEY CLUSTERED ([CreditReasonCategoryID] ASC);
GO

