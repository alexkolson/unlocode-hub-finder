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
`

class App extends Component {
  render() {
    return (
      <Query query={GET_HUBS} >
      </Query>
    );
  }
}

export default App;
