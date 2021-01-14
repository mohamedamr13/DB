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
    public partial class ViewAssignmentContent : System.Web.UI.Page
    {

        DataTable AssignCont = new DataTable();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ViewAssignContent(object sender, EventArgs e)
        {

            try
            {
                String connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
                SqlConnection conn = new SqlConnection(connStr);

                int CourseID = Int16.Parse(cid.Text);
                int InstructorID = Int16.Parse(insid.Text);
                int stu_id = (int)Session["user"];

                SqlCommand ViewAssignContentProc = new SqlCommand("viewAssign", conn);
                ViewAssignContentProc.CommandType = CommandType.StoredProcedure;
                ViewAssignContentProc.Parameters.Add(new SqlParameter("@Sid", stu_id));
                ViewAssignContentProc.Parameters.Add(new SqlParameter("@courseId", CourseID));
                SqlParameter returnParameter = ViewAssignContentProc.Parameters.Add("@result", SqlDbType.VarChar, 20);
                returnParameter.Direction = ParameterDirection.Output;

                AssignCont.Columns.Add("CourseID");
                AssignCont.Columns.Add("Assignment Type");
                AssignCont.Columns.Add("Assignment Number");
                AssignCont.Columns.Add("Content");
                AssignCont.Columns.Add("Full Grade");
                AssignCont.Columns.Add("Weight");
                AssignCont.Columns.Add("Deadline");



                conn.Open();
                ViewAssignContentProc.ExecuteNonQuery();
                conn.Close();


                SqlCommand EnrolledStudent = new SqlCommand("enrollInCourse", conn);
                EnrolledStudent.CommandType = CommandType.StoredProcedure;
                EnrolledStudent.Parameters.Add(new SqlParameter("@sid", stu_id));
                EnrolledStudent.Parameters.Add(new SqlParameter("@cid", CourseID));
                EnrolledStudent.Parameters.Add(new SqlParameter("@instr", InstructorID));
                SqlParameter flag = EnrolledStudent.Parameters.Add("@flag", SqlDbType.VarChar, 5);
                flag.Direction = ParameterDirection.Output;

                conn.Open();
                EnrolledStudent.ExecuteNonQuery();
                conn.Close();

                string ret = EnrolledStudent.Parameters["@flag"].Value.ToString();

                //conn.Open();


                //EnrolledStudent.ExecuteNonQuery();
                //conn.Close();
                //SqlParameter return_Parameter2 = EnrolledStudent.Parameters.Add("@result_cid", SqlDbType.Int);
                //return_Parameter2.Direction = ParameterDirection.Output;

                //string ret = EnrolledStudent.Parameters["@flag"].Value.ToString();
                if (ret == "true")
                {
                    contentTable.Visible = false;
                    msg.Text = "<p style='color:red'>" + "You are not enrolled in this course" + "</p>";
                }

                if (returnParameter.Value.ToString() == "not a user")
                {
                    contentTable.Visible = false;
                    msg.Text = "<p style='color:red'>" + "Please enter your correct ID" + "</p>";
                }

                //else if((int?)(return_Parameter1.Value) == StudentID && (int?)(return_Parameter2.Value) != CourseID)
                //{
                //    msg.Text = "<p style='color:red'>" + "You are not enrolled in this course" + "</p>";
                //}


                else
                {

                    SqlCommand assigns = new SqlCommand("viewAssign", conn);
                    assigns.CommandType = CommandType.StoredProcedure;

                    assigns.Parameters.Add(new SqlParameter("@Sid", stu_id));
                    assigns.Parameters.Add(new SqlParameter("@courseId", CourseID));

                    SqlParameter retParam = assigns.Parameters.Add("@result", SqlDbType.VarChar, 20);
                    retParam.Direction = ParameterDirection.Output;
                    conn.Open();
                    SqlDataReader rdr = assigns.ExecuteReader(CommandBehavior.CloseConnection);
                    while (rdr.Read())
                    {
                        String assignContent;
                        


                        try
                        {
                             assignContent = rdr.GetString(rdr.GetOrdinal("content"));
                        }
                        catch {
                             assignContent = "No Content Yet";
                        }

                        //AssignCont.Columns.Add("CourseID");
                        //AssignCont.Columns.Add("Assignment Type");
                        //AssignCont.Columns.Add("Assignment Number");
                        //AssignCont.Columns.Add("Content");
                        //AssignCont.Columns.Add("Full Grade");
                        //AssignCont.Columns.Add("Weight");
                        //AssignCont.Columns.Add("Deadline");
                        contentTable.Visible = true;
                        AssignCont.Rows.Add(rdr.GetInt32(rdr.GetOrdinal("cid")), rdr.GetString(rdr.GetOrdinal("type")), rdr.GetInt32(rdr.GetOrdinal("number")), assignContent, rdr.GetInt32(rdr.GetOrdinal("fullGrade")), rdr.GetDecimal(rdr.GetOrdinal("weight")), rdr.GetDateTime(rdr.GetOrdinal("deadline")));

                        contentTable.DataSource = AssignCont;
                        contentTable.DataBind();

                        //Label content = new Label();
                        //content.Text = assignContent + " ";
                        //Label line = new Label();

                        //line.Text = "</br>";

                        //form1.Controls.Add(content);

                        //form1.Controls.Add(line);



                    }

                    conn.Close();



                }
            }

             catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Something went wrong, please press ok and check error message')", true);
                if (cid.Text == "" || insid.Text == "")
                {
                    contentTable.Visible = false;
                    msg.Text = "<p style='color:red'>" + "Please fill in all the required fields" + "</p>";

                }
                //else {
                //  msg.Text=   ex.Message;
                //}

            }
        }
    }
}
