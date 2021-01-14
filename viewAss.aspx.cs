using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Gucera
{
    public partial class viewAss : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {


            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand proc = new SqlCommand("InstructorViewAssignmentsStudents", conn);
            proc.CommandType = CommandType.StoredProcedure;
            int insId = (int)Session["user"];
            int cid = (int)Session["course"];
            proc.Parameters.Add(new SqlParameter("@instrId", insId));
            proc.Parameters.Add(new SqlParameter("@cid", cid));

            conn.Open();
            SqlDataReader rdr = proc.ExecuteReader(CommandBehavior.CloseConnection);
            while (rdr.Read())
            {

                int id = rdr.GetInt32(rdr.GetOrdinal("sid"));
                int ccid = rdr.GetInt32(rdr.GetOrdinal("cid"));
                int num = rdr.GetInt32(rdr.GetOrdinal("assignmentNumber"));

                String type = rdr.GetString(rdr.GetOrdinal("assignmenttype"));
                int grade = -1;
                try
                {
                    grade = rdr.GetInt32(rdr.GetOrdinal("grade"));
                }
                catch (System.Data.SqlTypes.SqlNullValueException)
                {

                }
                catch (System.InvalidCastException)
                {

                }
                finally
                {
                    String s = "               ";
                    TableRow row = new TableRow();
                    ///////////  create new row
                    TableCell course = new TableCell();
                    course.Text = s + ccid.ToString();

                    TableCell st = new TableCell();
                    st.Text = s + id.ToString();

                    TableCell typ = new TableCell();
                    typ.Text = s + type;

                    TableCell number = new TableCell();
                    number.Text = s + num.ToString();

                    TableCell gr = new TableCell();
                    if (grade == -1)
                        gr.Text = s + "-";
                    else
                        gr.Text = s + grade.ToString();

                    row.Cells.Add(course);
                    row.Cells.Add(st);
                    row.Cells.Add(typ);
                    row.Cells.Add(number);
                    row.Cells.Add(gr);

                    a1.Rows.Add(row);




                }








            }
        }
        protected void dash(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            Response.Redirect("Course.aspx");
        }
    }
}