Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.Web.UI.WebControls

Partial Public Class EmployeeList
    Inherits System.Web.UI.Page

    Private Property SortExpressionValue As String
        Get
            Return Convert.ToString(If(ViewState("SortExpression"), "EmpCode"))
        End Get
        Set(value As String)
            ViewState("SortExpression") = value
        End Set
    End Property

    Private Property SortDirectionValue As String
        Get
            Return Convert.ToString(If(ViewState("SortDirection"), "ASC"))
        End Get
        Set(value As String)
            ViewState("SortDirection") = value
        End Set
    End Property

    Protected Sub Page_Load(
        ByVal sender As Object,
        ByVal e As EventArgs
    ) Handles Me.Load

        If Not IsPostBack Then
            SortExpressionValue = "EmpCode"
            SortDirectionValue = "ASC"

            LoadCompanies()
            LoadEmployees()
        End If

    End Sub

    Private Sub LoadCompanies()

        Dim dt As DataTable =
            Universal.GetData("usp_CodeRef_GetCompanies")

        ddlCompany.DataSource = dt
        ddlCompany.DataTextField = "CompanyName"
        ddlCompany.DataValueField = "CompanyCode"
        ddlCompany.DataBind()

        ddlCompany.Items.Insert(
            0,
            New ListItem("All Companies", "")
        )

    End Sub

    Private Function GetEmployeeData() As DataTable

        Dim parameters As New List(Of SqlParameter)()

        parameters.Add(
            Universal.Parameter(
                "@CompanyCode",
                ddlCompany.SelectedValue,
                SqlDbType.VarChar,
                10
            )
        )

        parameters.Add(
            Universal.Parameter(
                "@Status",
                ddlStatus.SelectedValue,
                SqlDbType.VarChar,
                20
            )
        )

        Return Universal.GetData(
            "usp_Employee_GetList",
            parameters
        )

    End Function

    Private Sub LoadEmployees()

        Try
            Dim dt As DataTable = GetEmployeeData()

            If dt Is Nothing Then
                gvEmployees.DataSource = Nothing
                gvEmployees.DataBind()
                lblRecordCount.Text = "0 employee(s)"
                Return
            End If

            Dim view As DataView = dt.DefaultView

            If dt.Columns.Contains(SortExpressionValue) Then
                view.Sort =
                    SortExpressionValue & " " & SortDirectionValue
            End If

            gvEmployees.DataSource = view
            gvEmployees.DataBind()

            lblRecordCount.Text =
                dt.Rows.Count.ToString() & " employee(s)"

            lblMessage.Visible = False

        Catch ex As Exception

            gvEmployees.DataSource = Nothing
            gvEmployees.DataBind()

            lblRecordCount.Text = "0 employee(s)"
            lblMessage.Text =
                "Unable to load employee records. Please contact administrator."
            lblMessage.Visible = True

        End Try

    End Sub

    Protected Sub FilterChanged(
        ByVal sender As Object,
        ByVal e As EventArgs
    )

        LoadEmployees()

    End Sub

    Protected Sub btnRefresh_Click(
        ByVal sender As Object,
        ByVal e As EventArgs
    )

        ddlCompany.SelectedIndex = 0
        ddlStatus.SelectedValue = "All"
        txtSearch.Text = String.Empty

        SortExpressionValue = "EmpCode"
        SortDirectionValue = "ASC"

        LoadEmployees()

    End Sub

    Protected Sub gvEmployees_Sorting(
        ByVal sender As Object,
        ByVal e As GridViewSortEventArgs
    )

        If SortExpressionValue = e.SortExpression Then
            SortDirectionValue =
                If(SortDirectionValue = "ASC", "DESC", "ASC")
        Else
            SortExpressionValue = e.SortExpression
            SortDirectionValue = "ASC"
        End If

        LoadEmployees()

    End Sub

    Protected Function GetStatusCss(ByVal status As Object) As String

        If Convert.ToString(status).Equals(
            "Active",
            StringComparison.OrdinalIgnoreCase
        ) Then

            Return "status-badge status-active"

        End If

        Return "status-badge status-inactive"

    End Function

End Class
