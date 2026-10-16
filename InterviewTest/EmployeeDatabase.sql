IF DB_ID('InterViewTest') IS NULL
BEGIN
    CREATE DATABASE InterViewTest;
END
GO

USE InterViewTest;
GO

IF OBJECT_ID('dbo.CodeRef', 'U') IS NOT NULL DROP TABLE dbo.CodeRef;
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL DROP TABLE dbo.Employee;
GO

CREATE TABLE dbo.CodeRef
(
    CodeType varchar(10) NOT NULL,
    Code varchar(10) NOT NULL,
    Title varchar(100) NULL,
    CreatedBy varchar(500) NULL,
    CreatedDate datetime NULL,
    ModifyBy varchar(500) NULL,
    ModifyDate datetime NULL,
    CONSTRAINT PK_CodeRef PRIMARY KEY (CodeType, Code)
);
GO

CREATE TABLE dbo.Employee
(
    CompanyCode varchar(10) NOT NULL,
    EmpCode varchar(10) NOT NULL,
    EmployeeName varchar(100) NOT NULL,
    AliasName varchar(100) NOT NULL,
    ICNO varchar(20) NULL,
    SectionCode varchar(10) NULL,
    DepartmentCode varchar(10) NULL,
    DesignationCode varchar(10) NULL,
    JoinDate date NULL,
    ResignDate date NULL,
    CreatedBy varchar(500) NOT NULL,
    CreatedDate datetime NOT NULL,
    ModifyBy varchar(500) NULL,
    ModifyDate datetime NULL,
    CONSTRAINT PK_Employee PRIMARY KEY (CompanyCode, EmpCode)
);
GO

INSERT INTO dbo.CodeRef
(CodeType, Code, Title, CreatedBy, CreatedDate)
VALUES
('COM', '001', 'ABC Dynamics Pte Ltd', 'SYSTEM', GETDATE()),
('DES', 'FINM', 'Finance Manager', 'SYSTEM', GETDATE()),
('DES', 'HRE', 'HR Executive', 'SYSTEM', GETDATE()),
('DES', 'ITE', 'IT Executive', 'SYSTEM', GETDATE()),
('DES', 'ITM', 'IT Manager', 'SYSTEM', GETDATE()),
('DES', 'ITSE', 'IT Senior Engineer', 'SYSTEM', GETDATE()),
('DPT', 'FIN', 'Finance Services', 'SYSTEM', GETDATE()),
('DPT', 'HR', 'Human Resources', 'SYSTEM', GETDATE()),
('DPT', 'IT', 'Information Technology', 'SYSTEM', GETDATE());
GO

INSERT INTO dbo.Employee
(CompanyCode, EmpCode, EmployeeName, AliasName, ICNO, SectionCode,
 DepartmentCode, DesignationCode, JoinDate, ResignDate, CreatedBy, CreatedDate)
VALUES
('001', '001', 'Lucky Mee', 'Lucky', 'A134557', NULL, 'IT', 'ITE',
 '2020-01-10', NULL, 'SYSTEM', GETDATE()),
('001', '002', 'John Teo', 'John', 'A736376', NULL, 'IT', 'ITSE',
 '2021-01-10', NULL, 'SYSTEM', GETDATE()),
('001', '003', 'Megan Lim', 'Megan', 'Y6252676', NULL, 'HR', 'HRE',
 '2018-09-13', '2022-03-10', 'SYSTEM', GETDATE()),
('001', '004', 'Johny Lee', 'Johny', 'E653536', NULL, 'FIN', 'FINM',
 '2018-11-13', '2040-03-10', 'SYSTEM', GETDATE());
GO

CREATE OR ALTER PROCEDURE dbo.usp_CodeRef_GetCompanies
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Code AS CompanyCode,
        Title AS CompanyName
    FROM dbo.CodeRef
    WHERE CodeType = 'COM'
    ORDER BY Title;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_CodeRef_GetByType
    @CodeType varchar(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Code, Title
    FROM dbo.CodeRef
    WHERE CodeType = @CodeType
    ORDER BY Title;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_Employee_GetList
    @CompanyCode varchar(10) = NULL,
    @Status varchar(20) = 'All'
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.EmpCode,
        E.EmployeeName,
        E.AliasName,
        E.ICNO,
        E.SectionCode,
        ISNULL(D.Title, '') AS Department,
        ISNULL(G.Title, '') AS Designation,
        CASE
            WHEN E.ResignDate IS NULL OR E.ResignDate > CAST(GETDATE() AS date)
                THEN 'Active'
            ELSE 'Resigned'
        END AS Status
    FROM dbo.Employee E
    LEFT JOIN dbo.CodeRef D
        ON D.CodeType = 'DPT'
       AND D.Code = E.DepartmentCode
    LEFT JOIN dbo.CodeRef G
        ON G.CodeType = 'DES'
       AND G.Code = E.DesignationCode
    WHERE
        (@CompanyCode IS NULL OR @CompanyCode = '' OR E.CompanyCode = @CompanyCode)
        AND
        (
            @Status = 'All'
            OR
            (
                @Status = 'Active Staff'
                AND (E.ResignDate IS NULL OR E.ResignDate > CAST(GETDATE() AS date))
            )
        );
END
GO
