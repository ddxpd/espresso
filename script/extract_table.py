#!/home/badassgirl/pymupdf_venv/bin/python
import os
import fitz

class ParseTableFromPDF():

  def print_error(self, line):
    print("Error: " + line)
    exit()

  def print_warning(self, line):
    print("Warning: " + line)

  def update_table_name(self, line):
    table_name = line.strip(" \n").split(":")[-1].strip("' ").replace(" ", "_").replace("–", "_")
    start_new_table = 0
    if (table_name != self.table_name):
      self.table_name = table_name
      #create a new file
      self.csv_write_mode = "w"
      self.table_head = []
      self.head_column_cnt = 0
      self.table_rows = []
      self.column_per_row = 0
    else:
      self.csv_write_mode = "a"

  def table_row_to_csv_line(self, row):
    s = "" 
    for col in row:
      s += col + ", "
    s = s.replace("\n", " ")
    s = s.strip(", ")+"\n"
    return s

  def process_table(self, rows):
    table_head = []
    for col in rows[0]:
      if col != "" and col != None:
        table_head.append(col)
    if self.head_column_cnt != 0 and self.head_column_cnt != len(table_head):
        self.print_warning("{} head column cnt - previous: {}, current: {}".format(self.table_name, self.head_column_cnt, len(table_head)))
    else:
      self.table_head = table_head
      self.head_column_cnt = len(table_head)
      self.column_per_row = self.head_column_cnt

    for i in range(1, len(rows)):
      row = rows[i]
      table_content = []
      col_cnt = 0
      for col in row:
        col_cnt += 1
        if col != None:
          if ":" in col and col_cnt != 1:
            col = col.split(":")[0]
          table_content.append(col)
      if self.column_per_row != len(table_content):
          self.print_warning("{} row {} content column cnt - previous: {}, current: {}".format(self.table_name, (i+1), self.column_per_row, len(table_content)))
          s = self.table_row_to_csv_line(table_content)
          self.print_warning("{} will be discarded".format(s.strip("\n")))
      else:
        self.table_rows.append(table_content)

    csv_file_name = self.table_name + ".csv"
    fname = os.path.join(self.csv_folder, csv_file_name)
    self.csv_fname = fname
    f = open(self.csv_fname, self.csv_write_mode)
    if self.csv_write_mode == "w":
      s = self.table_row_to_csv_line(self.table_head)
      f.writelines(s)
    for row in self.table_rows:
      s = self.table_row_to_csv_line(row)
      f.writelines(s)
    f.close()
    print ("CSV file output at {}".format(fname))
    self.table_rows = []


  def extract_table(self):
    for page in self.pages:
      self.current_page += 1
      if self.current_page in self.pages_to_detect:
        tbl = page.find_tables()
        if len(tbl.tables) != 0:
          print("Find table on page {}".format(self.current_page))
          txt = page.get_text("text")
          for line in txt.split("\n"):
            if line.strip(" \n").startswith("Figure "):
              self.update_table_name(line)
          for obj in tbl.tables:
            self.process_table(obj.extract())

  def __init__(self, fpath):
    if not os.path.isfile(fpath):
      self.print_error("{} does not exist. Please check file path.".format(fpath))
    self.csv_folder = "../doc/csv"
    self.csv_fname = ""
    self.pages = fitz.open(fpath)
    self.pages_to_detect = [74, 75, 76, 77]
    self.current_page = 0
    #self.pages_to_detect = [74]
    self.table_name = ""
    self.table_head = []
    self.head_column_cnt = 0
    self.table_rows = []
    self.column_per_row = 0
    self.csv_write_mode = "w"
    s = ""
    for p in self.pages_to_detect:
      s += "{}, ".format(p)
    s = s.strip(", ")
    print("Search tables on page {}".format(s))

nvme_base_spec = ParseTableFromPDF("../doc/nvme_protocol/NVM-Express-Base-Specification-Revision-2.1-2024.08.05-Ratified.pdf")
nvme_base_spec.extract_table()