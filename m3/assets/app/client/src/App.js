import React, { useState, useEffect, Fragment } from "react";
import axios from "axios";
import styled from "styled-components";
import { useTable, usePagination } from "react-table";

const Styles = styled.div`
    padding: 1rem;

    table {
        border-spacing: 0;
        border: 1px solid #ededed;
    }
    table tr:last-child td {
        border-bottom: 0;
    }
    table th,
    table td {
        margin: 0;
        padding: 0.5rem;
        border-bottom: 1px solid #ededed;
        border-right: 1px solid #ededed;
        position: relative;
    }
    table th:last-child,
    table td:last-child {
        border-right: 0;
    }
    table tr:nth-child(even) {
        background-color: #fafafa;
    }

    table th::before {
        position: absolute;
        right: 15px;
        top: 16px;
        content: "";
        width: 0;
        height: 0;
        border-left: 5px solid transparent;
        border-right: 5px solid transparent;
    }
    table th.sort-asc::before {
        border-bottom: 5px solid #22543d;
    }
    table th.sort-desc::before {
        border-top: 5px solid #22543d;
    }

    .App {
        display: flex;
        flex-direction: column;
        padding: 20px;
    }

    input {
        padding: 10px;
        margin-bottom: 20px;
        font-size: 18px;
        border-radius: 5px;
        border: 1px solid #ddd;
        box-shadow: none;
    }

    .pagination {
        padding: 0.5rem;
    }
`;

// Let's add a fetchData method to our Table component that will be used to fetch
// new data when pagination state changes
// We can also add a loading state to let our table know it's loading new data
function Table({ columns, data, setQuery, setSize, setPageNumber, loading }) {
    const {
        getTableProps,
        getTableBodyProps,
        headerGroups,
        prepareRow,
        page,
        canPreviousPage,
        canNextPage,
        pageOptions,
        pageCount,
        gotoPage,
        nextPage,
        previousPage,
        setPageSize,
        // Get the state from the instance
        state: { pageIndex, pageSize },
    } = useTable(
        {
            columns,
            data: data.content,
            initialState: { pageIndex: 0 }, // Pass our hoisted table state
            manualPagination: true, // Tell the usePagination
            // hook that we'll handle our own data fetching
            // This means we'll also have to provide our own
            // pageCount.
            pageCount: data.totalPages,
        },
        usePagination
    );
    const [filterInput, setFilterInput] = useState("");

    // Listen for changes in pagination and use the state to fetch our new data
    React.useEffect(() => {
        setPageNumber(pageIndex);
    }, [setPageNumber, pageIndex]);

    React.useEffect(() => {
        setSize(pageSize);
        setPageNumber(0);
    }, [setSize, pageSize, setPageNumber]);

    React.useEffect(() => {
        setQuery(filterInput);
        setPageNumber(0);
    }, [setPageNumber, setQuery, filterInput]);

    const handleFilterChange = (e) => {
        const value = e.target.value || "";
        setFilterInput(value);
    };

    // Render the UI for your table
    return (
        <Fragment>
            <input
                value={filterInput}
                onChange={handleFilterChange}
                placeholder={"Search maker, model, year or trim"}  
                ref={(input) => {input && input.focus() }}
            />
            <table {...getTableProps()}>
                <thead>
                    {headerGroups.map((headerGroup) => (
                        <tr {...headerGroup.getHeaderGroupProps()}>
                            {headerGroup.headers.map((column) => (
                                <th {...column.getHeaderProps()}>
                                    {column.render("Header")}
                                    <span>
                                        {column.isSorted
                                            ? column.isSortedDesc
                                                ? " 🔽"
                                                : " 🔼"
                                            : ""}
                                    </span>
                                </th>
                            ))}
                        </tr>
                    ))}
                </thead>
                <tbody {...getTableBodyProps()}>
                    {page.map((row, i) => {
                        prepareRow(row);
                        return (
                            <tr {...row.getRowProps()}>
                                {row.cells.map((cell) => {
                                    return (
                                        <td {...cell.getCellProps()}>
                                            {cell.render("Cell")}
                                        </td>
                                    );
                                })}
                            </tr>
                        );
                    })}
                    <tr>
                        {loading ? (
                            // Use our custom loading state to show a loading indicator
                            <td colSpan="10000">Loading...</td>
                        ) : (
                            <td colSpan="10000">
                                Showing {page.length} of ~
                                {data.totalPages * pageSize} results
                            </td>
                        )}
                    </tr>
                </tbody>
            </table>
            {/* 
        Pagination can be built however you'd like. 
        This is just a very basic UI implementation:
      */}
            <div className="pagination">
                <button onClick={() => gotoPage(0)} disabled={!canPreviousPage}>
                    {"<<"}
                </button>{" "}
                <button
                    onClick={() => previousPage()}
                    disabled={!canPreviousPage}
                >
                    {"<"}
                </button>{" "}
                <button onClick={() => nextPage()} disabled={!canNextPage}>
                    {">"}
                </button>{" "}
                <button
                    onClick={() => gotoPage(pageCount - 1)}
                    disabled={!canNextPage}
                >
                    {">>"}
                </button>{" "}
                <span>
                    Page{" "}
                    <strong>
                        {pageIndex + 1} of {pageOptions.length}
                    </strong>{" "}
                </span>
                <span>
                    | Go to page:{" "}
                    <input
                        type="number"
                        defaultValue={pageIndex + 1}
                        onChange={(e) => {
                            const page = e.target.value
                                ? Number(e.target.value) - 1
                                : 0;
                            gotoPage(page);
                        }}
                        style={{ width: "100px" }}
                    />
                </span>{" "}
                <select
                    value={pageSize}
                    onChange={(e) => {
                        setPageSize(Number(e.target.value));
                    }}
                >
                    {[10, 20, 30, 40, 50].map((pageSize) => (
                        <option key={pageSize} value={pageSize}>
                            Show {pageSize}
                        </option>
                    ))}
                </select>
            </div>
        </Fragment>
    );
}

function App() {
    const columns = React.useMemo(
        () => [
            {
                Header: "Info",
                columns: [
                    {
                        Header: "Maker",
                        accessor: "maker",
                    },
                    {
                        Header: "Model",
                        accessor: "model",
                    },
                    {
                        Header: "Year",
                        accessor: "year",
                    },
                    {
                        Header: "Trim",
                        accessor: "trim",
                    },
                ],
            },
        ],
        []
    );

    // We'll start our table without any data
    const [data, setData] = React.useState({
        content: [],
        size: 0,
    });
    const [pageNumber, setPageNumber] = React.useState(0);
    const [pageSize, setPageSize] = React.useState(20);
    const [query, setQuery] = React.useState("");
    const [loading, setLoading] = React.useState(false);

    useEffect(() => {
        (async () => {
            try {
                setLoading(true);
                console.log(query);
                const result = await axios(
                    "http://localhost:8001/search?q=" +
                        query +
                        "&page=" +
                        pageNumber +
                        "&size=" +
                        pageSize
                );
                setLoading(false);
                setData(result.data);
            } catch (error) {
                setLoading(false);
            }
        })();
    }, [query, pageNumber, pageSize]);

    return (
        <Styles>
            <Table
                columns={columns}
                data={data}
                setQuery={setQuery}
                setSize={setPageSize}
                setPageNumber={setPageNumber}
                loading={loading}
            />
        </Styles>
    );
}

export default App;
