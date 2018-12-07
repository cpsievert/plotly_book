readxl::read_excel(
  #"https://community.tableau.com/servlet/JiveServlet/downloadBody/1236-102-2-15278/Sample%20-%20Superstore.xls"
  "~/Downloads/Sample - Superstore.xls"
) %>%
  select(
    id = `Customer ID`,
    category = Category,
    sub_category = `Sub-Category`,
    order_date = `Order Date`,
    sales = Sales
  ) %>%
  readr::write_csv("data/sales.csv")