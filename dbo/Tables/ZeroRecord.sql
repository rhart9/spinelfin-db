CREATE TABLE [dbo].[ZeroRecord] (
    [ZeroRecordID]               INT            IDENTITY (1, 1) NOT NULL,
    [AccountID]                  INT            NOT NULL,
    [ReferenceDate]              DATE           NOT NULL,
    [Notes]                      NVARCHAR (MAX) NULL,
    [LegacySpinelfinRef]         INT            NULL,
    [Reconciled]                 BIT            NULL,
    [CreatedDT]                  DATETIME       CONSTRAINT [DF_ZeroRecord_CreatedDT] DEFAULT (getdate()) NOT NULL,
    [UpdatedDT]                  DATETIME       CONSTRAINT [DF_ZeroRecord_UpdatedDT] DEFAULT (getdate()) NOT NULL,
    [ProcessedInLegacy]          BIT            CONSTRAINT [DF_ZeroRecord_ProcessedInLegacy] DEFAULT ((0)) NOT NULL,
    [PreviousLegacyZeroRecordID] INT            NULL,
    [ZeroRecordCategoryID]       INT            NULL,
    [CategoryMonthID]            INT            NULL,
    [AllowNoSplits]              BIT            CONSTRAINT [DF_ZeroRecord_AllowNoSplits] DEFAULT ((0)) NOT NULL,
    [ExportToLegacy]             BIT            CONSTRAINT [DF_ZeroRecord_ExportToLegacy] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ZeroRecord] PRIMARY KEY CLUSTERED ([ZeroRecordID] ASC),
    CONSTRAINT [FK_ZeroRecord_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID]),
    CONSTRAINT [FK_ZeroRecord_CategoryMonth] FOREIGN KEY ([CategoryMonthID]) REFERENCES [dbo].[CategoryMonth] ([CategoryMonthID]),
    CONSTRAINT [FK_ZeroRecord_ZeroRecord] FOREIGN KEY ([PreviousLegacyZeroRecordID]) REFERENCES [dbo].[ZeroRecord] ([ZeroRecordID]),
    CONSTRAINT [FK_ZeroRecord_ZeroRecordCategory] FOREIGN KEY ([ZeroRecordCategoryID]) REFERENCES [dbo].[ZeroRecordCategory] ([ZeroRecordCategoryID])
);
GO







