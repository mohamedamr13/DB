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
    public partial class ListCertificates : System.Web.UI.Page
    {
        DataTable certList = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Certificates(object sender, EventArgs e)
        {
            try
            {
                String connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
                SqlConnection conn = new SqlConnection(connStr);

                int CourseID = Int16.Parse(cid.Text);
                int stu_id = (int)Session["user"];


                SqlCommand CertificateProc = new SqlCommand("viewCertificate", conn);
                CertificateProc.CommandType = CommandType.StoredProcedure;

                CertificateProc.Parameters.Add(new SqlParameter("@sid", stu_id));
                CertificateProc.Parameters.Add(new SqlParameter("@cid", CourseID));

                SqlParameter res = CertificateProc.Parameters.Add("@result", SqlDbType.VarChar, 60);
                res.Direction = ParameterDirection.Output;

                //certList.Columns.Add("Course Name");
                certList.Columns.Add("Course ID");
                //certList.Columns.Add("Credit Hours");
                certList.Columns.Add("Issue Date");

                conn.Open();
                CertificateProc.ExecuteNonQuery();
                conn.Close();

                string error = CertificateProc.Parameters["@result"].Value.ToString();
                conn.Open();

                if (error == "student not enrolled in course or did not finish course")
                {
                    certificatesTable.Visible = false;
                    err.Text = "<p style='color:red'>" + "You are not enrolled in this course or you haven't finished it yet" + "</p>";
                }

                else
                {
                    err.Text = "";
                    SqlDataReader rdr = CertificateProc.ExecuteReader(CommandBehavior.CloseConnection);

                    if (!rdr.HasRows)
                    {
                        certificatesTable.Visible = false;
                        err.Text = "<p style='color:red'>" + "You are not enrolled in this course or you haven't finished it yet" + "</p>";
                    }
                    else {
                        while (rdr.Read())
                        {
                            //DateTime cert = rdr.GetDateTime(rdr.GetOrdinal("issueDate"));
                            //Label certify = new Label();
                            //details.Text = "This student with a Student ID: " + sid.Text + " has earned a certificate for the course with a Course ID: " + cid.Text + " and its issue date is: " + cert.ToString();
                            //form1.Controls.Add(certify);
                            certificatesTable.Visible = true;
                            certList.Rows.Add(rdr.GetInt32(rdr.GetOrdinal("cid")), rdr.GetDateTime(rdr.GetOrdinal("issueDate")));
                            certificatesTable.DataSource = certList;
                            certificatesTable.DataBind();

                        }
                    }
                }

                conn.Close();
            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Something went wrong, please press ok and check error message')", true);
                if (cid.Text == "")
                {
                    details.Text = "";
                    err.Text = "<p style='color:red'>" + "Please fill in all the required fields" + "</p>";

                }
                

            }
        }
    }
}