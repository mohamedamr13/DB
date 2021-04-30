import java.io.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

import javax.swing.table.TableCellEditor;

import com.sun.javadoc.Type;
import com.sun.jdi.ReferenceType;

//import jdk.vm.ci.meta.Local;

public class DBApp implements DBAppInterface {
	String globalPath;
	private int maxPageCount;
	String localPath = "\\src\\main\\resources\\data\\";

	public DBApp() {
		init();
	}

	@Override
	public void init() {

		Properties prop = new Properties();
		String fileName = "app.config";
		InputStream is = null;
		try {
			is = new FileInputStream(System.getProperty("user.dir") + "\\src\\main\\resources\\DBApp.config");
		} catch (FileNotFoundException ex) {
		}
		try {
			prop.load(is);
		} catch (IOException ex) {

		}
		maxPageCount = Integer.parseInt(prop.getProperty("MaximumRowsCountinPage"));
		globalPath = System.getProperty("user.dir");
	}

	@Override
	public void createTable(String tableName, String clusteringKey, Hashtable<String, String> colNameType,
			Hashtable<String, String> colNameMin, Hashtable<String, String> colNameMax) throws DBAppException {

		ArrayList<String[]> tableNames = readCSV(globalPath + "\\src\\main\\resources\\tableNames.csv");

		for (String[] s : tableNames)
			for (String s1 : s) {
				if (s1.equals(tableName))
					throw new DBAppException("Table already exists");
			}

		Set cols = colNameType.keySet();
		Set min = colNameMin.keySet();
		Set max = colNameMax.keySet();

		if (!cols.containsAll(min) || !cols.containsAll(max))
			throw new DBAppException(" Missing/Invalid column metadata from one of the hashdata ");

		if (!min.containsAll(cols) || !min.containsAll(max))
			throw new DBAppException(" Missing/Invalid column metadata from one of the hashdata ");

		if (!max.containsAll(cols) || !max.containsAll(min))
			throw new DBAppException("Missing/Invalid column metadata from one of the hashdata ");

		if (!cols.contains(clusteringKey))
			throw new DBAppException("Clustering Key not included in Columns");

		List<List<String>> row = new ArrayList<List<String>>();
		for (Object col : cols) {
			String column = (String) col;

			ArrayList<String> s1 = new ArrayList<String>();
			s1.add(tableName);
			s1.add((column));
			// System.out.print(column + " ");

			s1.add(colNameType.get(column));
			// System.out.println((colNameType.get(column)));

			if (column.equals(clusteringKey)) {
				s1.add("True");
			} else {
				s1.add("False");
			}
			s1.add("False");
			s1.add(colNameMin.get(column));
			// System.out.println((colNameMin.get(column)));

			s1.add(colNameMax.get(column));
			// System.out.println((colNameMax.get(column)));

			row.add(s1);

		}

		writeCSV("/src/main/resources/metadata.csv", row);

		String[] tableNameString = { tableName };
		List<String> tableNameList = Arrays.asList(tableNameString);

		List<List<String>> tableNameRow = Arrays.asList(tableNameList);
		writeCSV("/src/main/resources/tableNames.csv", tableNameRow);

		String s = System.getProperty("user.dir");
		s += localPath;
		s += tableName;
		File test = new File(s);
		test.mkdir();

		Table newTable = new Table();
		newTable.pk = clusteringKey;
		String tablePath = "./src/main/resources/data/";
		tablePath += tableName + "/Table.class";
		try {
			FileOutputStream fileOut = new FileOutputStream(tablePath);
			ObjectOutputStream out = new ObjectOutputStream(fileOut);
			out.writeObject(newTable);
			out.close();
			fileOut.close();
		} catch (IOException i) {
			i.printStackTrace();
		}

	}

	@Override
	public void createIndex(String tableName, String[] columnNames) throws DBAppException {

	}

//	@Override
//	public void insertIntoTable(String tableName, Hashtable<String, Object> colNameValue) throws DBAppException {
//		// TODO Auto-generated method stub
//
//		// verify table name and colNameValue

//		// get primary key
//		// Load Table
//		// Load Pages ArrayList
//		// check noPages Flag
//		// else
//		// apply insert method
//		// page not full -> insert + update range
//		// page full , check Pages Arraylist
//		// If all pages full
//		// Case1 : according to Dr :
//		// Go to desired page - split to 2 pages - update range + DO NOT LOAD AND SHIFT
//		// ALL PAGES
//		// CASE 2
//		// CREATE NEW PAGE AT THE END OF PAGES AND LOAD AND SHIFT EVERY SINGLE PAGE
//		// Else
//		// Some page after desired page is not full
//		// Load and shift all pages until you reach that page - update range for every
//		// page
//
//	}

	@Override
	public void insertIntoTable(String tableName, Hashtable<String, Object> colNameValue) throws DBAppException {
		// TODO Auto-generated method stub

		String tablePath = globalPath + "\\src\\main\\resources\\data\\" + tableName + "\\Table.class";

		ArrayList<String[]> tableNames = readCSV(globalPath + "\\src\\main\\resources\\tableNames.csv");

		ArrayList<String[]> metaDataArray = readCSV(globalPath + "\\src\\main\\resources\\metadata.csv");

		boolean tableExists = true;
		for (String[] s : tableNames)
			for (String s1 : s) {
				if (s1.equals(tableName)) {
					tableExists = false;
				}
			}

		if (tableExists) {
			throw new DBAppException("Table does not exist");
		}

		ArrayList<String[]> filteredArray = (ArrayList<String[]>) metaDataArray.stream()
				.filter(a -> a[0].equals(tableName)).collect(Collectors.toList());

		Set colNames = colNameValue.keySet();
		inputChecker(colNames, filteredArray, colNameValue);

		Table table = (Table) deSerialize(tablePath);
		if (table.noPages) {
			firstPageRoutine(colNameValue, table, tableName);

		} else {
			// Go to Insert Method to find Page ID
			String pageID = insert(colNameValue.get(table.pk), table.pages);
			if (pageID.equals("-1")) {

				pageID = outOfRangeRoutine(colNameValue, table);

			}

			System.out.println(" PAGE ID " + pageID);
			Page virtPage = null;
			for (Page p : table.pages) {
				if (p.id.equals(pageID))
					virtPage = p;
			}

			System.out.println(virtPage.id);

			System.out.println(table);
			Vector page = ((Vector) deSerialize(globalPath + localPath + tableName + "\\" + pageID + ".class"));

			insertTuple(page, colNameValue, table.pk, virtPage, table, tableName, virtPage.id);
		}

	}

	void insertTuple(Vector<Hashtable<String, Object>> page, Hashtable<String, Object> colNameValue, String pk,
			Page virtPage, Table table, String tableName, String virtPageId) throws DBAppException {

		// LinkedList tempPage = new LinkedList();
		int OldpageSize = page.size();
		int insertInHere = 0;
		for (int i = OldpageSize - 1; i >= 0; i--) {

			Hashtable<String, Object> tuple = (Hashtable<String, Object>) page.get(i);
			// System.out.println(colNameValue.get("id"));
			if (compare(tuple.get(pk), colNameValue.get(pk)) == 0)
				throw new DBAppException("Tuple arleady exists in Table");
			else if (compare(tuple.get(pk), colNameValue.get(pk)) < 0) {
				insertInHere = i + 1;
				break;
//			} else {
//				tempPage.addFirst(page.remove(i));
//			}
			}
		}
		page.add(insertInHere, colNameValue);

//		for (Hashtable<String, Object> h : page)
//			System.out.print(h.get(pk) + " ");
//
//		System.out.println();

		Vector<Hashtable<String, Object>> newPage = new Vector();
		if (OldpageSize == maxPageCount) {
			int j = (OldpageSize + 1) / 2;
			for (int i = 0; i < OldpageSize / 2 + 1; i++)
				newPage.add(page.remove(j));

			// page : old page
			// new page: new page
			// grab maxPage
			String maxId = table.maxPageId;
			int maxIdInt = Integer.parseInt(maxId) + 1;
			table.maxPageId = maxIdInt + "";
			// create new Page
			Page newVirtPage = new Page(((Hashtable) newPage.get(0)).get(pk),
					((Hashtable) newPage.get(newPage.size() - 1)).get(pk), table.maxPageId);

			// update old page
			virtPage.min = ((Hashtable) page.get(0)).get(pk);
			virtPage.max = ((Hashtable) page.get(page.size() - 1)).get(pk);
			virtPage.isFull = false;

			table.pages.add(table.pages.indexOf(virtPage) + 1, newVirtPage);

			serialize(table, globalPath + "\\src\\main\\resources\\data\\" + tableName + "\\" + "Table" + ".class");
			serialize(page, globalPath + "\\src\\main\\resources\\data\\" + tableName + "\\" + virtPageId + ".class");
			serialize(newPage,
					globalPath + "\\src\\main\\resources\\data\\" + tableName + "\\" + table.maxPageId + ".class");

		}

		else {
			if (OldpageSize == maxPageCount - 1) {
				virtPage.isFull = true;
			}
			virtPage.min = ((Hashtable) page.get(0)).get(pk);
			virtPage.max = ((Hashtable) page.get(page.size() - 1)).get(pk);

			serialize(table, globalPath + localPath + tableName + "\\" + "Table" + ".class");
			serialize(page, globalPath + localPath + tableName + "\\" + virtPageId + ".class");

		}
		// update virtual old page and new if it exists

//		for (Object u : page) {
//
//			Hashtable<String, Object> h = (Hashtable<String, Object>) u;
//
//			System.out.print(h.get(pk) + " ");
//		}
//
//		System.out.println();
//
//		for (Object u : newPage) {
//
//			Hashtable<String, Object> h = (Hashtable<String, Object>) u;
//
//			System.out.print(h.get(pk) + " ");
//		}

	}

	void updateVirtTable(Vector page, Page virtPage, Table table, boolean newPage, String virtPageId,
			int virtPageIndex) {

		virtPage.max = ((Hashtable<String, Object>) page.get(page.size() - 1)).get(table.pk);
		virtPage.min = ((Hashtable<String, Object>) page.get(0)).get(table.pk);
		if (page.size() == maxPageCount)
			virtPage.isFull = true;

		if (newPage) {
			//
		}

	}

	String outOfRangeRoutine(Hashtable<String, Object> colNameValue, Table table) {
		String pageID = "";
		if (compare(colNameValue.get(table.pk), table.pages.get(0).min) < 0) {
			pageID = "1";
		} else {
			// Traverse pages from end to start until finding a page that has a max less
			// than the PK. Go to that page
			for (int i = table.pages.size() - 1; i >= 0; i--) {
				if (compare(table.pages.get(i).max, colNameValue.get(table.pk)) < 0) {
					if (i != table.pages.size() - 1 && table.pages.get(i).isFull && !table.pages.get(i + 1).isFull)
						pageID = table.pages.get(i + 1).id;
					else
						pageID = table.pages.get(i).id;

					break;
				}
			}
		}

		return pageID;
	}

	int compare(Object a, Object b) {

		if (a instanceof String) {
			return ((String) a).compareTo((String) b);
		} else if (a instanceof Date) {
			return ((Date) a).compareTo((Date) b);
		} else if (a instanceof Double) {
			return ((Double) a).compareTo((Double) b);
		} else {
			return ((Integer) a).compareTo((Integer) b);
		}
	}

	void inputChecker(Set colNames, ArrayList<String[]> filteredArray, Hashtable<String, Object> colNameValue)
			throws DBAppException {
		boolean flag = false;
		for (Object s : colNames) {
			int i = 0;
			while (i < filteredArray.size()) {
				if (s.equals((filteredArray.get(i)[1]))) {

					if (parseType(colNameValue.get(s), filteredArray.get(i)[2])) {

						if (MinMaxChecker(filteredArray.get(i), colNameValue.get(s))) {
							flag = true;
							break;

						} else {
							System.out.println(s);
							throw new DBAppException(" Illegal Argument;An input value is out of range ");
						}
					} else {
						System.out.println(s);

						throw new DBAppException("Illegal Arguemt;In correct Data type in one of the input values");
					}
				}
				i++;

			}
			if (flag == false) {
				throw new DBAppException("A column doesn't exist");
			}

		}

	}

	static boolean parseType(Object insrtObjt, String metadataType) {
		String type = metadataType.substring(10).toLowerCase();

		switch (type) {
		case "integer":
			return insrtObjt instanceof Integer;
		case "string":
			return insrtObjt instanceof String;
		case "double":
			return insrtObjt instanceof Double;
		case "date":
			return insrtObjt instanceof Date;
		default:
			return false;

		}

	}

	static Object returnType(String insrtObjt, String metadataType) {
		String type = metadataType.substring(10).toLowerCase();

		switch (type) {
		case "integer":
			return Integer.parseInt(insrtObjt);
		case "string":
			return insrtObjt;
		case "double":
			return Double.parseDouble(insrtObjt);
		case "date":
			return Date.parse(insrtObjt);
		default:
			return false;

		}

	}

	static Date returnDate(String dateString) {
		int year = Integer.parseInt(dateString.trim().substring(0, 4));
		int month = Integer.parseInt(dateString.trim().substring(5, 7));
		int day = Integer.parseInt(dateString.trim().substring(8));

		Date date = new Date(year - 1900, month - 1, day);

		return date;
	}

	public static boolean MinMaxChecker(String[] filteredArray, Object o) {

		switch (filteredArray[2].substring(10).toLowerCase()) {
		case "integer":
			// System.out.println("int");
			return Integer.parseInt(filteredArray[5]) <= (int) o && Integer.parseInt(filteredArray[6]) >= (int) o;
		case "string":
			// System.out.println("string");
			return filteredArray[5].compareTo((String) o) <= 0 && filteredArray[6].compareTo((String) o) >= 0;

		case "double":
			// System.out.println("double");
			return Double.parseDouble(filteredArray[5]) <= (double) o
					&& Double.parseDouble(filteredArray[6]) >= (double) o;
		case "date":
			// System.out.println("date");
			return returnDate(filteredArray[5]).compareTo((Date) o) <= 0
					&& returnDate(filteredArray[6]).compareTo((Date) o) >= 0;

		default:
			return false;
		}

	}

	void firstPageRoutine(Hashtable<String, Object> colNameValue, Table table, String tableName) {
		Vector serPage = new Vector(); // new Page
		serPage.add(colNameValue);
		Page newPage = new Page(colNameValue.get(table.pk), colNameValue.get(table.pk), "1");
		table.noPages = false;
		table.pages.add(newPage);
		table.maxPageId = "1";

		System.out.println(table);

		serialize(serPage, globalPath + localPath + tableName + "\\1.class");
		serialize(table, globalPath + localPath + tableName + "\\Table.class");

	}

	public static String insert(Object primaryKey, Vector<Page> v) {
		int l = 0, r = v.size() - 1;
		while (l <= r) {
			int m = l + (r - l) / 2;

			// Check if x is present at mid
			if (primaryKey instanceof Date) {
				Date DateKey = (Date) primaryKey;

				if (DateKey.compareTo((Date) v.get(m).min) >= 0 && DateKey.compareTo((Date) v.get(m).max) <= 0) {
					return v.get(m).getId();
				}

//				if (primaryKey >= v.get(m).min && primaryKey <= v.get(m).max) {
//					return m;
//				}

				if (DateKey.compareTo((Date) v.get(m).max) > 0)
					l = m + 1;

//				if (primaryKey > v.get(m).max)
//					l = m + 1;

				// If x is smaller, ignore right half
				else
					r = m - 1;
			}

			else if (primaryKey instanceof String) {
				String StringKey = (String) primaryKey;

				if (StringKey.compareTo((String) v.get(m).min) >= 0
						&& StringKey.compareTo((String) v.get(m).max) <= 0) {
					return v.get(m).getId();
				}

//				if (primaryKey >= v.get(m).min && primaryKey <= v.get(m).max) {
//					return m;
//				}

				if (StringKey.compareTo((String) v.get(m).max) > 0)
					l = m + 1;

//				if (primaryKey > v.get(m).max)
//					l = m + 1;

				// If x is smaller, ignore right half
				else
					r = m - 1;
			}

			else if (primaryKey instanceof Double) {
				Double IntKey = (Double) primaryKey;
				if (IntKey >= (Double) v.get(m).min && IntKey <= (Double) v.get(m).max) {
					return v.get(m).getId();
				}

				if (IntKey > (Double) v.get(m).max)
					l = m + 1;

				// If x is smaller, ignore right half
				else
					r = m - 1;
			} else {
				Integer IntKey = (int) primaryKey;
				if (IntKey >= (int) v.get(m).min && IntKey <= (int) v.get(m).max) {
					return v.get(m).getId();
				}

				if (IntKey > (int) v.get(m).max)
					l = m + 1;

				// If x is smaller, ignore right half
				else
					r = m - 1;
			}
		}
		return "-1";

		// if we reach here, then element was
		// not present

	}

	@Override
	public void updateTable(String tableName, String clusteringKeyValue, Hashtable<String, Object> columnNameValue)
			throws DBAppException {
		ArrayList<String[]> tableNames = readCSV(globalPath + "\\src\\main\\resources\\tableNames.csv");

		ArrayList<String[]> metaDataArray = readCSV(globalPath + "\\src\\main\\resources\\metadata.csv");

		ArrayList<String[]> filteredArray = (ArrayList<String[]>) metaDataArray.stream()
				.filter(a -> a[0].equals(tableName)).collect(Collectors.toList());

		boolean tableNotExist = true;
		for (String[] s : tableNames)
			for (String s1 : s) {
				if (s1.equals(tableName)) {
					tableNotExist = false;
				}
			}

		if (tableNotExist) {
			throw new DBAppException("Table does not exist");
		}
		Set colNames = columnNameValue.keySet();
		inputChecker(colNames, filteredArray, columnNameValue);

		String tablePath = globalPath + localPath + tableName + "\\Table.class";

		Table table = (Table) deSerialize(tablePath);

		if (table.noPages)
			throw new DBAppException("Cannot Update Empty Table");

		String type = "";
		for (String[] s1 : filteredArray) {
			if (s1[1].equals(table.pk))
				type = s1[2];
		}

		Object primValue = returnType(clusteringKeyValue, type);

		String pageId = insert(primValue, table.pages);
		if (pageId.equals("-1"))
			throw new DBAppException("Tuple Doesn't Exist");
		///////////////////////////////////////////// Add throw excpetion to method
		///////////////////////////////////////////// ////////////////

		Vector page = ((Vector) deSerialize(globalPath + localPath + tableName + "\\" + pageId + ".class"));

		int tupleIndex = binSearch(table.pk, primValue, page);

		if (tupleIndex == -1)
			throw new DBAppException("Tuple Doesn't Exist");

		Hashtable<String, Object> tuple = (Hashtable<String, Object>) page.get(tupleIndex);
		for (Object key : colNames) {
			tuple.put((String) key, columnNameValue.get(key));
		}

		serialize(page, globalPath + localPath + tableName + "\\" + pageId + ".class");
		serialize(table, globalPath + localPath + tableName + "\\" + "Table" + ".class");
	}

	@Override
	public void deleteFromTable(String tableName, Hashtable<String, Object> columnNameValue) throws DBAppException {
		ArrayList<String[]> tableNames = readCSV(globalPath + "\\src\\main\\resources\\tableNames.csv");

		ArrayList<String[]> metaDataArray = readCSV(globalPath + "\\src\\main\\resources\\metadata.csv");

		ArrayList<String[]> filteredArray = (ArrayList<String[]>) metaDataArray.stream()
				.filter(a -> a[0].equals(tableName)).collect(Collectors.toList());

		boolean tableExists = true;
		for (String[] s : tableNames)
			for (String s1 : s) {
				if (s1.equals(tableName)) {
					tableExists = false;
				}
			}

		if (tableExists) {
			throw new DBAppException("Table does not exist");
		}
		Set colNames = columnNameValue.keySet();
		inputChecker(colNames, filteredArray, columnNameValue);

		String tablePath = globalPath + localPath + tableName + "\\Table.class";

		Table table = (Table) deSerialize(tablePath);

		if (table.noPages)
			throw new DBAppException("Cannot Delete from empty table");
		String pk = table.pk;
		Object primKey = columnNameValue.get(pk);
		if (!colNames.contains(pk))
			noClusterKey(tableName, table, columnNameValue);
		else {

			String pageId = insert(primKey, table.pages);
			Vector page = ((Vector) deSerialize(globalPath + localPath + tableName + "\\" + pageId + ".class"));
			int index = binSearch(pk, primKey, page); // badal success khaletha index 3shan binSearch btraga3 el index
			if (index == -1) // i didn't find the element badal success khaletha index bardo ghayart el esm
								// bas
				throw new DBAppException(" Row doesn't exist ");
			else {
				Hashtable row = (Hashtable) page.get(index);
				for (Object s : colNames) {
					if (compare(row.get(s), columnNameValue.get(s)) != 0) { // hena b check law kol value fel row heya
																			// heya el value el fel hashtable el
																			// dakhlaly
						throw new DBAppException("row doesn't exist");
					}
				}
				page.remove(index); // hena h remove el tuple aw el row

			}

			Page p = null;
			for (Page p1 : table.pages) {
				if (p1.id.equals(pageId))
					p = p1;
			}

			if (page.isEmpty()) {
				File f = new File(globalPath + localPath + tableName + "\\" + pageId + ".class");
				f.delete();

				table.pages.remove(p);

				if (table.pages.isEmpty())
					table.noPages = true;
			}

			else {
				p.min = ((Hashtable<String, Object>) (page.get(0))).get(pk);
				p.max = ((Hashtable<String, Object>) (page.get(page.size() - 1))).get(pk);
				serialize(page, globalPath + localPath + tableName + "\\" + pageId + ".class");
				serialize(table, globalPath + localPath + tableName + "\\" + "Table" + ".class");

			}

		}
	}

	@SuppressWarnings("unchecked")
	void noClusterKey(String tableName, Table t, Hashtable<String, Object> columnNameValue) {

		Vector<Page> pages = t.pages;

		for (Page p : pages) {
			String id = p.id;
			Vector<Hashtable<String, Object>> page = ((Vector) deSerialize(
					globalPath + localPath + tableName + "\\" + id + ".class"));
			for (Hashtable<String, Object> row : page) {
				Set<String> cols = columnNameValue.keySet();
				boolean flag = true;
				for (String s : cols) {
					if (compare(columnNameValue.get(s), row.get(s)) != 0) {
						flag = false;
					}
				}

				if (flag == true)
					page.remove(row);

			}
			if (page.isEmpty()) {
				File f = new File(globalPath + localPath + tableName + "\\" + id + ".class");
				f.delete();

				t.pages.remove(p);

				if (t.pages.isEmpty())
					t.noPages = true;
				serialize(t, globalPath + localPath + tableName + "\\" + "Table" + ".class");

			} else {

				p.min = ((Hashtable<String, Object>) (page.get(0))).get(t.pk);
				p.max = ((Hashtable<String, Object>) (page.get(page.size() - 1))).get(t.pk);
				serialize(page, globalPath + localPath + tableName + "\\" + id + ".class");
				serialize(t, globalPath + localPath + tableName + "\\" + "Table" + ".class");

			}

		}

	}

	@Override
	public Iterator selectFromTable(SQLTerm[] sqlTerms, String[] arrayOperators) throws DBAppException {
		// TODO Auto-generated method stub
		return null;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static void main(String[] args) {
		DBApp a = new DBApp();

		// Date testDate = new Date();

		List x = new ArrayList<Object>();
		x.add("3");
		x.add(3);

//         String [] s = { "aa" };
//         System.out.println ( Arrays.toString(s) ) ;
//		try {
//			Thread.sleep(1000);
//		} catch (InterruptedException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} finally {
//			Date testDate2 = new Date();
//			System.out.println(a.compare(4, 4));
//			
//			// negative -> testDate older than testdate 2
//		}

//		ArrayList<String> p = new ArrayList<String>();
//		
//		System.out.println(Boolean.parseBoolean("FAlse"));
//		
//		Double x = (double) 3;
//		System.out.println( x );
//		

//		 
//		ArrayList<String[]> res = readCSV("C:\\Users\\Mohamed Amr\\Desktop\\Desktop\\GUC\\Semester 6\\DB II\\Project\\GUC_437_53_5863_2021-04-11T23_56_39\\DB2Project\\src\\main\\resources\\metadata.csv");
//		
//		for(String[] s : res) {
//			for(String s1 :s )
//				System.out.print(s1 + " ");
//			System.out.println();
//		}
		// ArrayList<String[]> s = readCSV("src/main/resources/metadata.csv");
		String strTableName = "Student1";
		String cluster = "id";

		Hashtable htblColNameType = new Hashtable();
		htblColNameType.put("id", "java.lang.Integer");
		htblColNameType.put("name", "java.lang.String");
		htblColNameType.put("gpa", "java.lang.double");

		Hashtable htblColNameMin = new Hashtable();
		htblColNameMin.put("id", "0");
		htblColNameMin.put("name", "a");
		htblColNameMin.put("gpa", "0.0");

		Hashtable htblColNameMax = new Hashtable();
		htblColNameMax.put("id", "10000");
		htblColNameMax.put("name", "zzzzzzz");
		htblColNameMax.put("gpa", "4.0");

		Hashtable htblColNameValue = new Hashtable();
		htblColNameValue.put("id", 80);
		htblColNameValue.put("name", "zzzz");
		htblColNameValue.put("gpa", 0.95);

//		Table table = new Table();
//		table.pk = "id";
//		Page p1 = new Page(18, 20, "1");
//		Page p2 = new Page(60, 90, "2");
//		Page p3 = new Page(100, 120, "3");
//		// p1.isFull = true;
//		table.pages.add(p1);
//		table.pages.add(p2);
//		table.pages.add(p3);

		// System.out.println(prop.getProperty("app.version"));
		// System.out.println(a.outOfRangeRoutine(htblColNameValue, table));
//
//		try {
////			 a.createTable(strTableName, cluster, htblColNameType, htblColNameMin,
////			 htblColNameMax);
//			a.insertIntoTable(strTableName, htblColNameValue);
//		} catch (DBAppException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
////
//		finally {
//			Vector<Hashtable<String, Object>> b = (Vector) a.deSerialize(
//					"C:\\Users\\Mohamed Amr\\Desktop\\Desktop\\GUC\\Semester 6\\DB II\\Project\\GUC_437_53_5863_2021-04-11T23_56_39\\DB2Project\\src\\main\\resources\\data\\Student30\\1.class");
//			for (Hashtable<String, Object> t : b) {
//
//				System.out.print(t.get("id") + " ");
//
//			}
//		}

//		Vector<Hashtable<String, Object>> b = (Vector) a.deSerialize(
//				"C:\\Users\\Mohamed Amr\\Desktop\\Desktop\\GUC\\Semester 6\\DB II\\Project\\GUC_437_53_5863_2021-04-11T23_56_39\\DB2Project\\src\\main\\resources\\data\\Student1\\1.class");
//		Vector<Hashtable<String, Object>> c = (Vector) a.deSerialize(
//				"C:\\Users\\Mohamed Amr\\Desktop\\Desktop\\GUC\\Semester 6\\DB II\\Project\\GUC_437_53_5863_2021-04-11T23_56_39\\DB2Project\\src\\main\\resources\\data\\Student1\\2.class");
//		Table table = (Table) a.deSerialize(
//				"C:\\Users\\Mohamed Amr\\Desktop\\Desktop\\GUC\\Semester 6\\DB II\\Project\\GUC_437_53_5863_2021-04-11T23_56_39\\DB2Project\\src\\main\\resources\\data\\Student1\\Table.class");
//		for (Hashtable<String, Object> t : b) {
//
//			System.out.print(t.get("id") + " ");
//
//		}
//		
//		System.out.println();
//		
//		for (Hashtable<String, Object> t : c) {
//
//			System.out.print(t.get("id") + " ");
//
//		}
//
//		
//		System.out.println();
//		System.out.println(table);
//		
//		

		ArrayList<String[]> metaDataArray = readCSV(a.globalPath + "\\src\\main\\resources\\metadata.csv");

		ArrayList<String[]> filteredArray = (ArrayList<String[]>) metaDataArray.stream()
				.filter(b -> b[0].equals("students")).collect(Collectors.toList());

////		Hashtable h1 = new Hashtable();
//		h1.put("id", "50-3400");
//		h1.put("dob", new Date("9/28/1990"));
//		h1.put("gpa", 3.32);
//		h1.put("first_name", "zzzzzzzzzzzzzzz");
//		h1.put("last_name", "ppLsdd");

		ArrayList<String[]> s = readCSV(
				"C:\\Users\\Mohamed Amr\\Desktop\\Desktop\\GUC\\Semester 6\\DB II\\Project\\GUC_437_53_5863_2021-04-11T23_56_39\\DB2Project\\src\\main\\resources\\students_table.csv");
//          int i = 0;
//         for(String [] s1 : s) {
//        		try {
//        			Hashtable h1 = new Hashtable();
//                    h1.put( "id" , s1[0]);
//            		h1.put("dob", s1[3]);
//            		h1.put("gpa", s1[4]);
//            		h1.put("first_name", s1[1]);
//            		h1.put("last_name", s1[2]);
//
//        			a.inputChecker(h1.keySet(), filteredArray, h1);
//        			System.out.println(i++);
//        		} catch (DBAppException e) {
//        			// TODO Auto-generated catch block
//        			e.printStackTrace();
//        		}
//
//         }

//
          int i = 0;
		for (String[] s1 : s) {
			try {
				Hashtable h1 = new Hashtable();
				h1.put("id", s1[0]);

	            int year = Integer.parseInt(s1[3].trim().substring(0, 4));
	            int month = Integer.parseInt(s1[3].trim().substring(5, 7));
	            int day = Integer.parseInt(s1[3].trim().substring(8));
	          
	            Date dob = new Date(year - 1900, month - 1, day);
				h1.put("dob", dob);
				h1.put("gpa", Double.parseDouble(s1[4]));
				h1.put("first_name", s1[1]);
				h1.put("last_name", s1[2]);
				
				System.out.println(i++);

				System.out.println(s1[3]);
				System.out.println("-----------------------");

				a.inputChecker(h1.keySet(), filteredArray, h1);
			} catch (DBAppException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

//		Date dob = new Date(2000 - 1900, 5 - 1, 5);
//		String[] c = filteredArray.get(3);
//		int year = Integer.parseInt(c[6].trim().substring(0, 4));
//		int month = Integer.parseInt(c[6].trim().substring(5, 7));
//		int day = Integer.parseInt(c[6].trim().substring(8));
//
//		Date max = new Date(year - 1900, month - 1, day);
//
//		System.out.println("max : " + max);
//		System.out.println("curr :  " + dob);
//		System.out.println(max.compareTo(dob));

//        Date max = new Date( 2000 - 1900 , 12-1 , 31 );

		// Set colNames = h1.keySet();
//		try {
//			a.inputChecker(colNames, filteredArray, h1);
//		} catch (DBAppException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}

//		
//		Table t = (Table) a.deSerialize(
//				"C:\\Users\\Mohamed Amr\\Desktop\\Desktop\\GUC\\Semester 6\\DB II\\Project\\GUC_437_53_5863_2021-04-11T23_56_39\\DB2Project\\data\\Student26\\Table.class");

		// System.out.println(t.toString());
//
//		Vector<Hashtable<String, Object>> page = new Vector<Hashtable<String, Object>>();
//
//		Hashtable h1 = new Hashtable();
//		h1.put("id", 50);
//
//		page.add(h1);
//
//		Hashtable h2 = new Hashtable();
//		h2.put("id", 100);
//
//		page.add(h2);
//
//		Hashtable h3 = new Hashtable();
//		h3.put("id", 120);

//		//Page p = new Page(50,100,"1" );
//		p.isFull = true;
//		Table table = new Table();
//		table.noPages = false;
//		table.maxPageId = "1";
//		table.pk = "id";
//		table.pages.add(p);

//		System.out.println(table);
//		
//		try {
//			a.insertTuple(page, h3, "id" , p, table, "tablename", "1");
//			System.out.println(table.toString());
//			for( Hashtable<String,Object> h : page ) {
//				for( String s: h.keySet() )
//					System.out.print( h.get(s)  + " ");
//				System.out.println();
//			}
//		} catch (DBAppException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}

	}

	public int binSearch(String pk, Object primaryKey, Vector<Hashtable<String, Object>> v) {
		int l = 0, r = v.size() - 1;
		while (l <= r) {
			int m = l + (r - l) / 2;

			// Check if x is present at mid
			Hashtable<String, Object> currRow = v.get(m);

			if (compare(currRow.get(pk), primaryKey) == 0) {
				return m;
			}

			else if (compare(primaryKey, currRow.get(pk)) > 0)
				l = m + 1;

			else
				r = m - 1;

		}
		return -1;

		// if we reach here, then element was
		// not present

	}

	@SuppressWarnings("finally")
	public static ArrayList<String[]> readCSV(String path) {
		// "C:\\Users\\Mohamed Amr\\Desktop\\Desktop\\GUC\\Semester 6\\DB
		// II\\Project\\GUC_437_53_5863_2021-04-11T23_56_39\\DB2Project\\src\\main\\resources\\metadata.csv"
		BufferedReader csvReader;
		ArrayList<String[]> res = new ArrayList<String[]>();
		try {
			csvReader = new BufferedReader(new FileReader(path));
			String row = null;
			while ((row = csvReader.readLine()) != null) {
				String[] data = row.split(",");
				res.add(data);
			}
			csvReader.close();

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			return res;
		}

	}

	void writeCSV(String path, List<List<String>> row) {
		FileWriter csvWriter;
		try {
			csvWriter = new FileWriter(globalPath + path, true);

			for (List<String> rowData : row) {
				csvWriter.append(String.join(",", rowData));
				csvWriter.append("\n");
			}

			csvWriter.flush();
			csvWriter.close();

		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

	}

	void serialize(Object serlzObj, String path) {
		try {
			FileOutputStream fileOut = new FileOutputStream(path);
			ObjectOutputStream out = new ObjectOutputStream(fileOut);
			out.writeObject(serlzObj);
			out.close();
			fileOut.close();
		} catch (IOException i) {
			i.printStackTrace();
		}
	}

	@SuppressWarnings("finally")
	Object deSerialize(String path) {
		Object out = null;
		try {
			FileInputStream fileIn = new FileInputStream(path);
			ObjectInputStream in = new ObjectInputStream(fileIn);
			out = in.readObject();
			in.close();
			fileIn.close();
		} catch (IOException i) {
			i.printStackTrace();
			return null;
		} catch (ClassNotFoundException c) {
			c.printStackTrace();
			return null;
		} finally {
			return out;
		}

	}

}
