import React, { Component } from 'react';

import ApolloClient, { gql } from 'apollo-boost';
import { Query } from 'react-apollo';

const client = new ApolloClient({
  uri: 'http://localhost:3000/graphql',
});


const GET_HUBS = gql`
query hubs($filter: QueryFilter, $order: QueryOrder, $page: Int, $pageSize: Int) {
  hubs(filter: $filter, order: $order, page: $page, pageSize: $pageSize) {
    page {
      ch,
      locode
      name,
      nameWoDiacritics,
      subDiv,
      function,
      status,
      date,
      iata,
      lat,
      lng,
      remarks
    }
  }
}
`;

class App extends Component {
  state = {
    queryVariables: {
      filter: null,
      order: null,
      page: null,
      pageSize: null,
    }
  }

  render() {
    return (
      <React.Fragment>
        <section>
          <h1>Controls</h1>
          <h2>Data Controls</h2>
          <button>Populate Hubs</button>
          <button>Delete Hubs</button>
          <h2>Query Controls</h2>
          <input type="text" />
        </section>
        <Query client={client} query={GET_HUBS} variables={this.state.queryVariables} >
          {({ loading, error, data }) => {
            if (loading) return <h1>Loading....</h1>
            if (error) return <h1 style={{ color: 'red' }}>Error loading hubs</h1>
            return (
              <table>
                <thead>
                  <tr>
                    <th>ch</th>
                    <th>locode</th>
                    <th>name</th>
                    <th>name without diacritics</th>
                    <th>subdiv</th>
                    <th>function</th>
                    <th>status</th>
                    <th>date</th>
                    <th>iata</th>
                    <th>lat</th>
                    <th>lng</th>
                    <th>view on map</th>
                    <th>remarks</th>
                  </tr>
                </thead>
                <tbody>
                  {data.hubs.page.map((hub) => (
                    <tr>
                      <td>{hub.ch}</td>
                      <td>{hub.locode}</td>
                      <td>{hub.name}</td>
                      <td>{hub.nameWoDiacritics}</td>
                      <td>{hub.subDiv}</td>
                      <td>{hub.function}</td>
                      <td>{hub.status}</td>
                      <td>{hub.date}</td>
                      <td>{hub.iata}</td>
                      <td>{hub.lat}</td>
                      <td>{hub.lng}</td>
                      <td><button>View On Map</button></td>
                      <td>{hub.remarks}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            );
          }}
        </Query>
      </React.Fragment>
    );
  }
}

export default App;
