function competitiveFund = loadfund(workbookFile, sheetName, dataLines)
%IMPORTFILE Import data from a spreadsheet
%  COMPETITIVEFUND = IMPORTFILE(FILE) reads data from the first
%  worksheet in the Microsoft Excel spreadsheet file named FILE.
%  Returns the data as a table.
%
%  COMPETITIVEFUND = IMPORTFILE(FILE, SHEET) reads from the specified
%  worksheet.
%
%  COMPETITIVEFUND = IMPORTFILE(FILE, SHEET, DATALINES) reads from the
%  specified worksheet for the specified row interval(s). Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  competitiveFund = importfile("G:\My Drive\Research\Documents\CV\経歴\業績\competitiveFund.xlsx", "competitiveFund", [2, 17]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 2021/04/13 23:28:17

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 2
    dataLines = [2, 1000];
end

%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 18);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "A" + dataLines(1, 1) + ":R" + dataLines(1, 2);

% Specify column names and types
opts.VariableNames = ["Institute_JP", "Institute_EN", "FundName_JP", "FundName_EN", "Title_JP", "Title_EN", "From", "To", "Name_JP", "Name_EN", "Budget_all", "Budget_direct", "Budget_indirect", "Permalink", "Abstract_JP", "Abstract_EN", "Type", "MemberType"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "double", "double", "categorical", "categorical", "double", "double", "double", "string", "string", "string", "double", "double"];

% Specify variable properties
opts = setvaropts(opts, ["Institute_JP", "Institute_EN", "FundName_JP", "FundName_EN", "Title_JP", "Title_EN", "Permalink", "Abstract_JP", "Abstract_EN"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Institute_JP", "Institute_EN", "FundName_JP", "FundName_EN", "Title_JP", "Title_EN", "Name_JP", "Name_EN", "Permalink", "Abstract_JP", "Abstract_EN"], "EmptyFieldRule", "auto");

% Import the data
competitiveFund = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:size(dataLines, 1)
    opts.DataRange = "A" + dataLines(idx, 1) + ":R" + dataLines(idx, 2);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    competitiveFund = [competitiveFund; tb]; %#ok<AGROW>
end

competitiveFund = competitiveFund(~(competitiveFund.Institute_JP==""),:);
competitiveFund.From = datetime(num2str(competitiveFund.From),'InputFormat','yyyyMMdd');
competitiveFund.To = datetime(num2str(competitiveFund.To),'InputFormat','yyyyMMdd');

end