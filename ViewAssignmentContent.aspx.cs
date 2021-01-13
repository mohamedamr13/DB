using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GUCera
{
    public partial class ViewAssignmentContent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ViewAssignContent(object sender, EventArgs e)
        {

            try
            {
                String connStr = WebConfigurationManager.ConnectionStrings["Milestone3"].ToString();
                SqlConnection conn = new SqlConnection(connStr);

                int CourseID = Int16.Parse(cid.Text);
                int StudentID = Int16.Parse(sid.Text);
                //int stu_id = (int)Session["user"]; --> replace every studentID with this

                SqlCommand ViewAssignContentProc = new SqlCommand("viewAssign", conn);
                ViewAssignContentProc.CommandType = CommandType.StoredProcedure;

                ViewAssignContentProc.Parameters.Add(new SqlParameter("@Sid", StudentID));
                ViewAssignContentProc.Parameters.Add(new SqlParameter("@courseId", CourseID));

                SqlParameter returnParameter = ViewAssignContentProc.Parameters.Add("@result", SqlDbType.VarChar, 20);
                returnParameter.Direction = ParameterDirection.Output;

                SqlCommand EnrolledStudent = new SqlCommand("enrollInCourse", conn);
                EnrolledStudent.CommandType = CommandType.StoredProcedure;

                EnrolledStudent.Parameters.Add(new SqlParameter("@sid", StudentID));
                EnrolledStudent.Parameters.Add(new SqlParameter("@cid", CourseID));

                SqlParameter flag = EnrolledStudent.Parameters.Add("@flag", SqlDbType.VarChar, 5);
                flag.Direction = ParameterDirection.Output;

                conn.Open();
                ViewAssignContentProc.ExecuteNonQuery();
                conn.Close();

                

                conn.Open(); //might need to take off


                //EnrolledStudent.ExecuteNonQuery();
                //conn.Close();
                //SqlParameter return_Parameter2 = EnrolledStudent.Parameters.Add("@result_cid", SqlDbType.Int);
                //return_Parameter2.Direction = ParameterDirection.Output;

                //string ret = EnrolledStudent.Parameters["@flag"].Value.ToString();
                if (flag.Value.ToString() == "1")
                {
                    msg.Text = "<p style='color:red'>" + "You are not enrolled in this course" + "</p>";
                }

                if (returnParameter.Value.ToString() == "not a user")
                {
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

                    assigns.Parameters.Add(new SqlParameter("@Sid", StudentID));
                    assigns.Parameters.Add(new SqlParameter("@courseId", CourseID));

                    SqlParameter retParam = assigns.Parameters.Add("@result", SqlDbType.VarChar, 20);
                    retParam.Direction = ParameterDirection.Output;
                    conn.Open();
                    SqlDataReader rdr = assigns.ExecuteReader(CommandBehavior.CloseConnection);
                    while (rdr.Read())
                    {
                        String assignContent = rdr.GetString(rdr.GetOrdinal("content"));
                        Label content = new Label();
                        if (assignContent == null)
                        {
                            content.Text = "There is no currect assignment content for this course";
                            form1.Controls.Add(content);
                        }
                        else
                        {
                            content.Text = assignContent;
                            form1.Controls.Add(content);
                        }
                    }

                    conn.Close();



                }
            }

            catch (ArgumentNullException)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Please enter all the required data')", true);
            }
            catch (ArgumentOutOfRangeException)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Please enter data in appropriate length')", true);
            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Please enter data')", true);
            }
        }
    }
}
