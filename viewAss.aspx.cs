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
            
        }


        protected void showAss (object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand proc = new SqlCommand("InstructorViewAssignmentsStudents",conn);
            proc.CommandType = CommandType.StoredProcedure;
            int insId = (int)Session["user"];
            int cid = Int32.Parse(id.Text);
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
                 grade = rdr.GetInt32(rdr.GetOrdinal("grade"));

                Label l = new Label();
                String s = "";
                  s+=  " Student ID :  " + id;
                s += "\r\n";
                s += "Course ID :  " + ccid;
                s += "\r\n";
                s += " Number : " + num;
                s += "\r\n";
                s += "Type : " + type;
                s += "\r\n";
                if (grade == -1)
                    s += "Grade :   -";
                else
                    s += "Grade : " + grade;



                l.Text = s;

                form1.Controls.Add(l);








            }

        }
    }
}