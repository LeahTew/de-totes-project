
def format_data(rows, column_names):
    """
    Args:
    takes a tuple of lists (the result of the SELECT\
    query on the payment_type) as the first argument.
    takes a list of column names as the second argument.

    Returns:
    List of dictionaries containing rows of data with column\
    titles as keys.
    """
    if isinstance(rows, list):
        rows_list = [list(rows)]
    else:
        rows_list = list(rows)

    nested_data_list = []

    for n in range(0, len(column_names)):
        data_list = []
        for row in rows_list:
            for elements in row:
                data_list.append(elements[n])

        nested_data_list.append(data_list)

    payment_type_dict = dict(zip(column_names, nested_data_list))
    return payment_type_dict
# potential errors
# no rows or columns exist, could not connect to database.
