import tkinter as tk
from tkinter import ttk
from tkinter import messagebox
import mysql.connector
import datetime

# Establish MySQL connection
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="techsavvy123",
    database="fashion1"
)
mycursor = mydb.cursor()

# Function to add a product
def add_product():
    add_window = tk.Toplevel(root)
    add_window.title("Add Product")

    pid_label = tk.Label(add_window, text="Product ID:")
    pid_label.grid(row=0, column=0, padx=10, pady=5)
    pid_entry = tk.Entry(add_window)
    pid_entry.grid(row=0, column=1, padx=10, pady=5)

    pname_label = tk.Label(add_window, text="Product Name:")
    pname_label.grid(row=1, column=0, padx=10, pady=5)
    pname_entry = tk.Entry(add_window)
    pname_entry.grid(row=1, column=1, padx=10, pady=5)

    brand_label = tk.Label(add_window, text="Brand:")
    brand_label.grid(row=2, column=0, padx=10, pady=5)
    brand_entry = tk.Entry(add_window)
    brand_entry.grid(row=2, column=1, padx=10, pady=5)

    product_for_label = tk.Label(add_window, text="Product for:")
    product_for_label.grid(row=3, column=0, padx=10, pady=5)
    product_for_entry = tk.Entry(add_window)
    product_for_entry.grid(row=3, column=1, padx=10, pady=5)

    season_label = tk.Label(add_window, text="Season:")
    season_label.grid(row=4, column=0, padx=10, pady=5)
    season_entry = tk.Entry(add_window)
    season_entry.grid(row=4, column=1, padx=10, pady=5)

    rate_label = tk.Label(add_window, text="Rate:")
    rate_label.grid(row=5, column=0, padx=10, pady=5)
    rate_entry = tk.Entry(add_window)
    rate_entry.grid(row=5, column=1, padx=10, pady=5)

    def save_product():
        pid = pid_entry.get()
        pname = pname_entry.get()
        brand = brand_entry.get()
        product_for = product_for_entry.get()
        season = season_entry.get()
        rate = rate_entry.get()

        # Insert data into database
        sql = "INSERT INTO product (product_id, PName, brand, Product_for, Season, rate) VALUES (%s, %s, %s, %s, %s, %s)"
        val = (pid, pname, brand, product_for, season, rate)
        mycursor.execute(sql, val)
        mydb.commit()
        messagebox.showinfo("Success", "Product added successfully!")
        add_window.destroy()

    save_btn = tk.Button(add_window, text="Save", command=save_product, width=20, height=2)
    save_btn.grid(row=6, columnspan=2, padx=10, pady=10)

# Function to view products
def view_product():
    view_window = tk.Toplevel(root)
    view_window.title("View Products")

    tree = ttk.Treeview(view_window)
    tree["columns"] = ("Product ID", "Product Name", "Brand", "Product For", "Season", "Rate")
    tree.heading("#0", text="", anchor="w")
    tree.heading("Product ID", text="Product ID")
    tree.heading("Product Name", text="Product Name")
    tree.heading("Brand", text="Brand")
    tree.heading("Product For", text="Product For")
    tree.heading("Season", text="Season")
    tree.heading("Rate", text="Rate")

    # Fetch data from database and insert into Treeview
    sql = "SELECT * FROM product"
    mycursor.execute(sql)
    rows = mycursor.fetchall()
    for row in rows:
        tree.insert("", "end", text="", values=row)

    tree.pack(expand=True, fill="both")

# Function to edit product
def edit_product():
    edit_window = tk.Toplevel(root)
    edit_window.title("Edit Product")

    def save_changes():
        pid = pid_entry.get()
        field = field_entry.get()
        new_value = new_value_entry.get()

        sql = f"UPDATE product SET {field} = %s WHERE product_id = %s"
        val = (new_value, pid)
        mycursor.execute(sql, val)
        mydb.commit()
        messagebox.showinfo("Success", "Changes saved successfully!")
        edit_window.destroy()

    pid_label = tk.Label(edit_window, text="Product ID:")
    pid_label.grid(row=0, column=0, padx=10, pady=5)
    pid_entry = tk.Entry(edit_window)
    pid_entry.grid(row=0, column=1, padx=10, pady=5)

    field_label = tk.Label(edit_window,text="Field to edit:")
    field_label.grid(row=1, column=0, padx=10, pady=5)
    field_entry = tk.Entry(edit_window)
    field_entry.grid(row=1, column=1, padx=10, pady=5)

    new_value_label = tk.Label(edit_window, text="New value:")
    new_value_label.grid(row=2, column=0, padx=10, pady=5)
    new_value_entry = tk.Entry(edit_window)
    new_value_entry.grid(row=2, column=1, padx=10, pady=5)

    save_btn = tk.Button(edit_window, text="Save Changes", command=save_changes, width=20, height=2)
    save_btn.grid(row=3, columnspan=2, padx=10, pady=10)

# Function to delete product
def delete_product():
    delete_window = tk.Toplevel(root)
    delete_window.title("Delete Product")

    def confirm_delete():
        pid = pid_entry.get()

        if messagebox.askyesno("Confirm Deletion", f"Are you sure you want to delete product with ID {pid}?"):
            sql = "DELETE FROM product WHERE product_id = %s"
            val = (pid,)
            mycursor.execute(sql, val)
            mydb.commit()
            messagebox.showinfo("Success", "Product deleted successfully!")
            delete_window.destroy()

    pid_label = tk.Label(delete_window, text="Product ID:")
    pid_label.grid(row=0, column=0, padx=10, pady=5)
    pid_entry = tk.Entry(delete_window)
    pid_entry.grid(row=0, column=1, padx=10, pady=5)

    delete_btn = tk.Button(delete_window, text="Delete Product", command=confirm_delete, width=20, height=2)
    delete_btn.grid(row=1, columnspan=2, padx=10, pady=10)

# Function to purchase product
def purchase_product():
    purchase_window = tk.Toplevel(root)
    purchase_window.title("Purchase Product")

    def save_purchase():
        pid = pid_entry
        pid = pid_entry.get()
        quantity = quantity_entry.get()

        # Fetch product details from the database
        sql_select_product = "SELECT PName, rate FROM product WHERE product_id = %s"
        mycursor.execute(sql_select_product, (pid,))
        product = mycursor.fetchone()

        if product:
            pname, rate = product
            amount = int(quantity) * rate

            # Insert purchase details into the database
            sql_insert_purchase = "INSERT INTO purchase (item_id, no_of_items, amount, purchase_date) VALUES (%s, %s, %s, %s)"
            purchase_date = datetime.datetime.now().strftime("%Y-%m-%d")
            purchase_data = (pid, quantity, amount, purchase_date)
            mycursor.execute(sql_insert_purchase, purchase_data)
            mydb.commit()

            # Update stock table
            sql_update_stock = "UPDATE stock SET Instock = Instock + %s WHERE item_id = %s"
            mycursor.execute(sql_update_stock, (quantity, pid))
            mydb.commit()

            messagebox.showinfo("Success", f"{quantity} units of {pname} purchased successfully!")
            purchase_window.destroy()
        else:
            messagebox.showerror("Error", f"Product with ID {pid} not found.")

    pid_label = tk.Label(purchase_window, text="Product ID:")
    pid_label.grid(row=0, column=0, padx=10, pady=5)
    pid_entry = tk.Entry(purchase_window)
    pid_entry.grid(row=0, column=1, padx=10, pady=5)

    quantity_label = tk.Label(purchase_window, text="Quantity:")
    quantity_label.grid(row=1, column=0, padx=10, pady=5)
    quantity_entry = tk.Entry(purchase_window)
    quantity_entry.grid(row=1, column=1, padx=10, pady=5)

    save_btn = tk.Button(purchase_window, text="Purchase", command=save_purchase, width=20, height=2)
    save_btn.grid(row=2, columnspan=2, padx=10, pady=10)

# Function to view purchases
def view_purchases():
    view_window = tk.Toplevel(root)
    view_window.title("View Purchases")

    tree = ttk.Treeview(view_window)
    tree["columns"] = ("Purchase ID", "Product ID", "No. of Items", "Amount", "Purchase Date")
    tree.heading("#0", text="", anchor="w")
    tree.heading("Purchase ID", text="Purchase ID")
    tree.heading("Product ID", text="Product ID")
    tree.heading("No. of Items", text="No. of Items")
    tree.heading("Amount", text="Amount")
    tree.heading("Purchase Date", text="Purchase Date")

    # Fetch data from the database and insert it into the Treeview
    sql_select_purchase = "SELECT * FROM purchase"
    mycursor.execute(sql_select_purchase)
    purchases = mycursor.fetchall()
    for purchase in purchases:
        tree.insert("", "end", text="", values=purchase)

    tree.pack(expand=True, fill="both")

# Function to view stock details
def view_stock():
    stock_window = tk.Toplevel(root)
    stock_window.title("View Stock")

    tree = ttk.Treeview(stock_window)
    tree["columns"] = ("Item ID", "Item Name", "Brand", "In Stock")
    tree.heading("#0", text="", anchor="w")
    tree.heading("Item ID", text="Item ID")
    tree.heading("Item Name", text="Item Name")
    tree.heading("Brand", text="Brand")
    tree.heading("In Stock", text="In Stock")

    # Fetch data from the database and insert it into the Treeview
    sql_select_stock = "SELECT * FROM stock"
    mycursor.execute(sql_select_stock)
    stocks = mycursor.fetchall()
    for stock in stocks:
        tree.insert("", "end", text="", values=stock)

    tree.pack(expand=True, fill="both")

# Function to sell item
def sell_item():
    sell_window = tk.Toplevel(root)
    sell_window.title("Sell Item")

    def save_sale():
        pid = pid_entry.get()
        quantity = quantity_entry.get()

        # Fetch product details from the database
        sql_select_product = "SELECT PName, rate FROM product WHERE product_id = %s"
        mycursor.execute(sql_select_product, (pid,))
        product = mycursor.fetchone()

        if product:
            pname, rate = product
            amount = int(quantity) * rate

            # Insert sale details into the database
            sql_insert_sale = "INSERT INTO sale (item_id, no_of_items, amount, sale_date) VALUES (%s, %s, %s, %s)"
            sale_date = datetime.datetime.now().strftime("%Y-%m-%d")
            sale_data = (pid, quantity, amount, sale_date)
            mycursor.execute(sql_insert_sale, sale_data)
            mydb.commit()

            # Update stock table
            sql_update_stock = "UPDATE stock SET Instock = Instock - %s WHERE item_id = %s"
            mycursor.execute(sql_update_stock, (quantity, pid))
            mydb.commit()

            messagebox.showinfo("Success", f"{quantity} units of {pname} sold successfully!")
            sell_window.destroy()
        else:
            messagebox.showerror("Error", f"Product with ID {pid} not found.")

    pid_label = tk.Label(sell_window, text="Product ID:")
    pid_label.grid(row=0, column=0, padx=10, pady=5)
    pid_entry = tk.Entry(sell_window)
    pid_entry.grid(row=0, column=1, padx=10, pady=5)

    quantity_label = tk.Label(sell_window, text="Quantity:")
    quantity_label.grid(row=1, column=0, padx=10, pady=5)
    quantity_entry = tk.Entry(sell_window)
    quantity_entry.grid(row=1, column=1, padx=10, pady=5)

    save_btn = tk.Button(sell_window, text="Sell", command=save_sale, width=20, height=2)
    save_btn.grid(row=2, columnspan=2, padx=10, pady=10)

def view_sales_details_gui():
    # Create a new window
    sales_window = tk.Toplevel(root)
    sales_window.title("View Sales Details")

    # Create a Treeview widget to display sales details
    tree = ttk.Treeview(sales_window)
    tree["columns"] = ("Sale ID", "Product ID", "No. of Items Sold", "Sale Rate", "Amount", "Sale Date")
    tree.heading("#0", text="", anchor="w")
    tree.heading("Sale ID", text="Sale ID")
    tree.heading("Product ID", text="Product ID")
    tree.heading("No. of Items Sold", text="No. of Items Sold")
    tree.heading("Sale Rate", text="Sale Rate")
    tree.heading("Amount", text="Amount")
    tree.heading("Sale Date", text="Sale Date")

    # Fetch data from the database and insert it into the Treeview
    sql_select_sale = "SELECT * FROM sales"
    mycursor.execute(sql_select_sale)
    sales_data = mycursor.fetchall()
    for sale in sales_data:
        tree.insert("", "end", text="", values=sale)

    tree.pack(expand=True, fill="both")


# Main GUI
root = tk.Tk()
root.title("Inventory Management System")
root.geometry("1000x600")

# Welcome message
welcome_label = tk.Label(root, text="Welcome to Fashion Management", font=("Helvetica", 18, "bold"))
welcome_label.pack(pady=20)

# Add buttons for various operations
button_style = {"bg": "#1E90FF", "fg": "white", "width": 20, "height": 2}

add_btn = tk.Button(root, text="Add Product", command=add_product, **button_style)
add_btn.pack(pady=5)
view_btn = tk.Button(root, text="View Product", command=view_product, **button_style)
view_btn.pack(pady=5)
edit_btn = tk.Button(root, text="Edit Product", command=edit_product, **button_style)
edit_btn.pack(pady=5)
delete_btn = tk.Button(root, text="Delete Product", command=delete_product, **button_style)
delete_btn.pack(pady=5)
purchase_btn = tk.Button(root, text="Purchase Product", command=purchase_product, **button_style)
purchase_btn.pack(pady=5)
view_purchases_btn = tk.Button(root, text="View Purchases", command=view_purchases, **button_style)
view_purchases_btn.pack(pady=5)
view_stock_btn = tk.Button(root, text="View Stock", command=view_stock, **button_style)
view_stock_btn.pack(pady=5)
sell_item_btn = tk.Button(root, text="Sell Item", command=sell_item, **button_style)
sell_item_btn.pack(pady=5)
view_sales_btn = tk.Button(root, text="View Sales Details", command=view_sales_details_gui, **button_style)
view_sales_btn.pack(pady=5)

root.mainloop()