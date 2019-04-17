import React, { Component } from 'react';

import ApolloClient, { gql } from 'apollo-boost';
import { Query } from 'react-apollo';

const client = new ApolloClient({
  uri: 'http://localhost:3000/graphql',
});


const GET_HUBS = gql`
{
  hubs {
    page {
      name,
      lat,
      lng
    }
  }
}
`;

class App extends Component {
  render() {
    return (
      <Query client={client} query={GET_HUBS} >
        {({ loading, error, data }) => {
          if (loading) return <h1>Loading....</h1>
          if (error) return <h1 style="color: red;">Error loading hubs</h1>
          return (
            <table>
              <thead>
                <th></th>
                <th></th>
                <th></th>
              </thead>
            </table>
          );
        }}
      </Query>
    );
  }
}

export default App;
