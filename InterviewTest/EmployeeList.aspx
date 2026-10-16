<%@ Page Language="VB" AutoEventWireup="false"
    CodeFile="EmployeeList.aspx.vb"
    Inherits="EmployeeList" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Employee List</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet" />
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <link href="CSS/EmployeeList.css" rel="stylesheet" />
</head>

<body>
<form id="form1" runat="server">

    <main class="container-fluid page-container">

        <section class="custom-card mb-4">
            <div class="custom-card-title-row">
                <div>
                    <div class="page-kicker">
                        <i class="bi bi-people-fill"></i> HR MANAGEMENT
                    </div>
                    <h1 class="custom-card-title">Employees List</h1>
                    <p class="page-subtitle">
                        View, filter, search and sort employee records.
                    </p>
                </div>

                <asp:Button ID="btnRefresh"
                    runat="server"
                    Text="Refresh"
                    CssClass="btn btn-outline-primary"
                    OnClick="btnRefresh_Click" />
            </div>

            <div class="filter-panel">
                <div class="row g-3 align-items-end">

                    <div class="col-12 col-md-4">
                        <label class="form-label" for="ddlCompany">
                            <i class="bi bi-building"></i> Company
                        </label>

                        <asp:DropDownList ID="ddlCompany"
                            runat="server"
                            CssClass="form-select"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="FilterChanged" />
                    </div>

                    <div class="col-12 col-md-4">
                        <label class="form-label" for="ddlStatus">
                            <i class="bi bi-person-check"></i> Employee Status
                        </label>

                        <asp:DropDownList ID="ddlStatus"
                            runat="server"
                            CssClass="form-select"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="FilterChanged">
                            <asp:ListItem Text="All Employees" Value="All" />
                            <asp:ListItem Text="Active Staff" Value="Active Staff" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-4">
                        <label class="form-label" for="txtSearch">
                            <i class="bi bi-search"></i> Search
                        </label>

                        <div class="search-wrapper">
                            <i class="bi bi-search search-icon"></i>

                            <asp:TextBox ID="txtSearch"
                                runat="server"
                                CssClass="form-control search-input"
                                placeholder="Search by code, name, department..."
                                onkeyup="filterEmployeeRows();" />
                        </div>
                    </div>

                </div>
            </div>
        </section>

        <section class="custom-card">
            <div class="custom-card-title-row report-heading">
                <div>
                    <h2 class="section-title">
                        <i class="bi bi-table"></i> Employee Directory
                    </h2>

                    <span class="record-summary">
                        <asp:Label ID="lblRecordCount" runat="server" />
                    </span>
                </div>

                <span class="sort-hint">
                    <i class="bi bi-arrow-down-up"></i>
                    Click a column heading to sort
                </span>
            </div>

            <asp:Label ID="lblMessage"
                runat="server"
                CssClass="alert alert-danger d-block"
                Visible="false" />

            <div class="table-responsive employee-table-wrapper">
                <asp:GridView ID="gvEmployees"
                    runat="server"
                    CssClass="table employee-table align-middle"
                    AutoGenerateColumns="False"
                    AllowSorting="True"
                    GridLines="None"
                    UseAccessibleHeader="true"
                    EmptyDataText="No employee records found."
                    OnSorting="gvEmployees_Sorting">

                    <Columns>
                        <asp:BoundField DataField="EmpCode"
                            HeaderText="Employee Code"
                            SortExpression="EmpCode" />

                        <asp:BoundField DataField="EmployeeName"
                            HeaderText="Employee Name"
                            SortExpression="EmployeeName" />

                        <asp:BoundField DataField="AliasName"
                            HeaderText="Alias Name"
                            SortExpression="AliasName" />

                        <asp:BoundField DataField="ICNO"
                            HeaderText="NRIC / FIN"
                            SortExpression="ICNO" />

                        <asp:BoundField DataField="SectionCode"
                            HeaderText="Section"
                            SortExpression="SectionCode" />

                        <asp:BoundField DataField="Department"
                            HeaderText="Department"
                            SortExpression="Department" />

                        <asp:BoundField DataField="Designation"
                            HeaderText="Designation"
                            SortExpression="Designation" />

                        <asp:TemplateField HeaderText="Status"
                            SortExpression="Status">
                            <ItemTemplate>
                                <span class='<%# GetStatusCss(Eval("Status")) %>'>
                                    <i class="bi bi-circle-fill"></i>
                                    <%# Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </section>

    </main>

</form>

<script>
    function filterEmployeeRows() {
        const input = document.getElementById('<%= txtSearch.ClientID %>');
        const table = document.getElementById('<%= gvEmployees.ClientID %>');

        if (!input || !table) return;

        const searchText = input.value.toLowerCase().trim();
        const rows = table.querySelectorAll('tbody tr');

        rows.forEach(function (row) {
            const rowText = row.innerText.toLowerCase();
            row.style.display = rowText.includes(searchText) ? '' : 'none';
        });
    }
</script>

</body>
</html>
