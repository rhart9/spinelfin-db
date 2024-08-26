
CREATE FUNCTION [reports].[fnCategoryReportByMonthCategoryWithBudget]
(	
	@CategoryYear int, 
	@CategoryMonth int,
	@CategoryType nvarchar(50)
)
RETURNS TABLE 
AS
RETURN 
(
	WITH cte_TransactionSplits AS (
		SELECT 
			r.ReferenceDate, 
			r.AccountName, 
			r.Description,
			r.P,
			r.Z,
			r.Amount,
			r.Credit,
			r.Debit,
			r.ReferenceID, 
			c.MonthID, 
			r.MonthlyBudgetID, 
			r.TransactionSplitID
		FROM reports.vCategoryReportRecords r
		INNER JOIN Category c ON r.CategoryID = c.CategoryID
		INNER JOIN CategoryMonth cm ON c.MonthID = cm.CategoryMonthID
		INNER JOIN CategoryType ct ON c.CategoryTypeID = ct.CategoryTypeID
		WHERE cm.YearValue = @CategoryYear AND cm.MonthValue = @CategoryMonth AND ct.ReconGroup = @CategoryType
	),
	cte_MonthlyBudgetBase AS (
		SELECT mb.MonthlyBudgetID, mb.MonthID, mb.AmountFrequency, ISNULL(mb.ReconFrequency, mb.AmountFrequency) AS ReconFrequency
		FROM budget.MonthlyBudget mb 
		INNER JOIN CategoryMonth cm ON mb.MonthID = cm.CategoryMonthID
		WHERE cm.YearValue = @CategoryYear AND cm.MonthValue = @CategoryMonth
	),
	cte_MonthlyBudgetExpandWeekly AS (
		SELECT mbb.MonthlyBudgetID, 1 AS RowNum
		FROM cte_MonthlyBudgetBase mbb
		WHERE mbb.AmountFrequency = 'M'
		UNION
		SELECT mbb.MonthlyBudgetID, ROW_NUMBER() OVER (PARTITION BY mbb.MonthlyBudgetID ORDER BY cw.StartDate) AS RowNum
		FROM cte_MonthlyBudgetBase mbb
		INNER JOIN CategoryWeek cw ON mbb.MonthID = cw.MonthID
		WHERE mbb.AmountFrequency = 'W'
	),
	cte_MonthlyBudgetContractWeekly AS (
		SELECT mbb.MonthlyBudgetID, mbb.ReconFrequency AS Frequency, CASE WHEN mbb.ReconFrequency = 'M' THEN 1 ELSE mbew.RowNum END AS RowNum
		FROM cte_MonthlyBudgetExpandWeekly mbew
		INNER JOIN cte_MonthlyBudgetBase mbb ON mbew.MonthlyBudgetID = mbb.MonthlyBudgetID
	),
	cte_MonthlyBudget AS (
		SELECT mb.MonthlyBudgetID, SUM(mb.BudgetAmount) AS Amount, mbcw.Frequency, mbcw.RowNum, bi.Name + CASE WHEN mbcw.Frequency = 'W' THEN ' Week ' + CAST(mbcw.RowNum AS nvarchar) ELSE '' END AS BudgetItem
		FROM cte_MonthlyBudgetContractWeekly mbcw
		INNER JOIN budget.MonthlyBudget mb ON mbcw.MonthlyBudgetID = mb.MonthlyBudgetID
		INNER JOIN budget.BudgetItem bi ON mb.BudgetItemID = bi.BudgetItemID
		GROUP BY mb.MonthlyBudgetID, bi.Name, mbcw.Frequency, mbcw.RowNum
	),
	cte_TransactionBudgetRowNumAbsolute AS (
		SELECT ts.TransactionSplitID, ts.Amount, ts.MonthlyBudgetID, ROW_NUMBER() OVER (PARTITION BY ts.MonthlyBudgetID ORDER BY ts.ReferenceDate, ts.TransactionSplitID) AS RowNum 
		FROM cte_TransactionSplits ts
	),
	cte_TransactionBudgetRowNum AS (
		SELECT tbrna.TransactionSplitID, tbrna.Amount, tbrna.MonthlyBudgetID, CASE WHEN mbb.ReconFrequency = 'M' THEN 1 ELSE tbrna.RowNum END AS RowNum
		FROM cte_TransactionBudgetRowNumAbsolute tbrna
		INNER JOIN cte_MonthlyBudgetBase mbb ON tbrna.MonthlyBudgetID = mbb.MonthlyBudgetID
	),
	cte_TransactionAmountByBudgetRowNum AS (
		SELECT tbrn.MonthlyBudgetID, tbrn.RowNum, SUM(tbrn.Amount) AS Amount
		FROM cte_TransactionBudgetRowNum tbrn
		GROUP BY tbrn.MonthlyBudgetID, tbrn.RowNum
	)
	SELECT 
		ts.ReferenceDate, 
		ts.AccountName, 
		ts.Description, 
		ts.P, 
		ts.Z, 
		ts.Amount,
		ts.Credit, 
		ts.Debit, 
		ts.ReferenceID, 
		mb.BudgetItem, 
		CASE WHEN mb.BudgetItem IS NOT NULL THEN ABS(ISNULL(tabrn.Amount, 0)) - ISNULL(mb.Amount, 0) END AS Variance, 
		ts.TransactionSplitID,
		ROW_NUMBER() OVER (ORDER BY CASE WHEN ts.TransactionSplitID IS NOT NULL THEN 1 ELSE 2 END, CASE WHEN ISNULL(ts.Credit, '') <> '' THEN 1 ELSE 2 END, ts.ReferenceDate, ts.TransactionSplitID) AS Sort
	FROM cte_TransactionSplits ts
	LEFT OUTER JOIN cte_TransactionBudgetRowNum tbrn ON ts.TransactionSplitID = tbrn.TransactionSplitID
	LEFT OUTER JOIN cte_TransactionAmountByBudgetRowNum tabrn ON tbrn.MonthlyBudgetID = tabrn.MonthlyBudgetID AND tbrn.RowNum = tabrn.RowNum
	FULL OUTER JOIN cte_MonthlyBudget mb ON tabrn.MonthlyBudgetID = mb.MonthlyBudgetID AND tabrn.RowNum = mb.RowNum
)
GO

