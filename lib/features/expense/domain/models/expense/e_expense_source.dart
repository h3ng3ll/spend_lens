/// Where an [Expense] record originated (design_spendlens.md §3). A
/// receipt-derived expense is generated from a saved [Receipt]; a cash
/// expense is entered directly through the Cash-expense sheet — see
/// `assets/SpendLens design system/SpendLens Prototype.dc.html` `cashExpense`
/// / `receipt` toast copy (`tDeleted`).
enum EExpenseSource { receipt, cash }
