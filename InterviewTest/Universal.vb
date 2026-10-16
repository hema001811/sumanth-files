Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Public NotInheritable Class Universal

    Private Sub New()
    End Sub

    Public Shared ReadOnly Property ConnectionString As String
        Get
            Dim cs As ConnectionStringSettings =
                ConfigurationManager.ConnectionStrings("InterviewTestConnection")

            If cs Is Nothing OrElse String.IsNullOrWhiteSpace(cs.ConnectionString) Then
                Throw New ConfigurationErrorsException(
                    "Connection string 'InterviewTestConnection' was not found.")
            End If

            Return cs.ConnectionString
        End Get
    End Property

    Public Shared Function GetData(
        ByVal storedProcedureName As String,
        Optional ByVal parameters As List(Of SqlParameter) = Nothing
    ) As DataTable

        Dim dt As New DataTable()

        Using con As New SqlConnection(ConnectionString)
            Using cmd As New SqlCommand(storedProcedureName, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = 60
                AddParameters(cmd, parameters)

                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using

        Return dt
    End Function

    Public Shared Function ExecuteNonQuery(
        ByVal storedProcedureName As String,
        Optional ByVal parameters As List(Of SqlParameter) = Nothing
    ) As Integer

        Using con As New SqlConnection(ConnectionString)
            Using cmd As New SqlCommand(storedProcedureName, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = 60
                AddParameters(cmd, parameters)

                con.Open()
                Return cmd.ExecuteNonQuery()
            End Using
        End Using
    End Function

    Public Shared Function ExecuteScalar(
        ByVal storedProcedureName As String,
        Optional ByVal parameters As List(Of SqlParameter) = Nothing
    ) As Object

        Using con As New SqlConnection(ConnectionString)
            Using cmd As New SqlCommand(storedProcedureName, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = 60
                AddParameters(cmd, parameters)

                con.Open()
                Return cmd.ExecuteScalar()
            End Using
        End Using
    End Function

    Public Shared Function Parameter(
        ByVal name As String,
        ByVal value As Object,
        ByVal dbType As SqlDbType,
        Optional ByVal size As Integer = 0
    ) As SqlParameter

        Dim p As New SqlParameter(name, dbType)

        If size > 0 Then p.Size = size

        If value Is Nothing OrElse
           value Is DBNull.Value OrElse
           String.IsNullOrWhiteSpace(Convert.ToString(value)) Then
            p.Value = DBNull.Value
        Else
            p.Value = value
        End If

        Return p
    End Function

    Private Shared Sub AddParameters(
        ByVal cmd As SqlCommand,
        ByVal parameters As List(Of SqlParameter)
    )

        If parameters Is Nothing Then Return

        For Each p As SqlParameter In parameters
            cmd.Parameters.Add(p)
        Next
    End Sub

End Class
