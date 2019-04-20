import React, { Fragment, Component } from 'react';

import ApolloClient, { gql } from 'apollo-boost';
import { Query, Mutation } from 'react-apollo';

const client = new ApolloClient({
  uri: 'http://localhost:3000/graphql',
});

const DELETE_HUBS = gql`
  mutation destroyHubs {
    destroyHubs {
      success,
      errors
    }
  }
`;

const POPULATE_HUBS = gql`
  mutation populateHubs {
    populateHubs {
      success,
      errors
    }
  }
`;

const GET_HUBS = gql`
query hubs($filter: QueryFilter, $order: QueryOrder, $page: Int, $pageSize: Int) {
  hubs(filter: $filter, order: $order, page: $page, pageSize: $pageSize) {
    page {
      id,
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

const NEAREST_HUB_TO_ADDRESS = gql`
query nearestHubToAddress($address: String!) {
  nearestHubToAddress(address: $address) {
    id
  }
}
`;

const NEAREST_HUB_TO_COORDINATES = gql`
query nearestHubToCoordinates($lat: Float!, $lng: Float!) {
  nearestHubToCoordinates(lat: $lat, lng: $lng) {
    id
  }
}
`;

class App extends Component {
  state = {
    queryVariables: {
      filter: null,
      order: null,
      page: 1,
      pageSize: 10,
    }
  }

  async findNearestHubToAddress() {
    const queryResponse = await client.query({
      query: NEAREST_HUB_TO_ADDRESS,
      variables: {
        address: document.querySelector('#address').value
      }
    });

    this.setState({
      queryVariables: {
        filter: {
          key: 'id',
          value: queryResponse.data.nearestHubToAddress.id
        },
      },
    });
  }

  findNearestHubToUserLocation() {
    navigator.geolocation.getCurrentPosition(async (location) => {
      const queryResponse = await client.query({
        query: NEAREST_HUB_TO_COORDINATES,
        variables: {
          lat: location.coords.latitude,
          lng: location.coords.longitude
        }
      });

      this.setState({
        queryVariables: {
          filter: {
            key: 'id',
            value: queryResponse.data.nearestHubToCoordinates.id
          },
        },
      });
    });
  }

  updateQueryVariables() {
    const filterKey = document.querySelector('#filter-key').value;
    const filterValue = document.querySelector('#filter-value').value;

    const orderKey = document.querySelector('#order-key').value;
    const orderDesc = !!document.querySelector('#order-desc:checked')

    let filter;
    let order;

    if (!filterKey) {
      filter = null;
    } else {
      filter = {
        key: filterKey,
        value: filterValue,
      };
    }

    if (!orderKey) {
      order = null;
    } else {
      order = {
        key: orderKey,
        desc: orderDesc,
      };
    }
    this.setState({
      queryVariables: {
        filter,
        order,
        page: parseInt(document.querySelector('#page').value, 10) || 1,
        pageSize: parseInt(document.querySelector('#page-size').value, 10) || 10
      }
    });
  }

  render() {
    return (
      <Fragment>
        <h1>Controls</h1>
        <h2>Data Controls</h2>
        <Mutation mutation={POPULATE_HUBS} client={client} refetchQueries={[{ query: GET_HUBS, variables: this.state.queryVariables }]}>
          {(populateHubs, { loading, error }) => (
            <Fragment>
              <button onClick={populateHubs}>Populate Hubs</button>
              {loading && <p>Populating Hubs...This could take some time. This message will disappear when hubs are populated. You will also then see data in the table below.</p>}
              {error && <p style={{ color: 'red' }}> Error: {error} :( Please try again</p>}
            </Fragment>
          )}
        </Mutation>
        <Mutation mutation={DELETE_HUBS} client={client} refetchQueries={[{ query: GET_HUBS, variables: this.state.queryVariables }]}>
          {(deleteHubs, { loading, error }) => (
            <Fragment>
              <button onClick={deleteHubs}>Delete Hubs</button>
              {loading && <p>Deleting Hubs....</p>}
              {error && <p style={{ color: 'red' }}> Error: {error} :( Please try again</p>}
            </Fragment>
          )}
        </Mutation>
        <h2>Query Controls</h2>
        <h3>Filter</h3>
        <select id="filter-key">
          <option value="">---Select a key to filter on---</option>
          <option>ch</option>
          <option>locode</option>
          <option>name</option>
          <option value="name_wo_diacritics">name without diacritics</option>
          <option value="sub_div">subdiv</option>
          <option>function</option>
          <option>status</option>
          <option>date</option>
          <option>iata</option>
          <option>lat</option>
          <option>lng</option>
          <option>remarks</option>
        </select>
        <input type="text" placeholder="filter value" id="filter-value" name="filter-value" />
        <h3>Order</h3>
        <select id="order-key">
          <option value="">---Select a key to order by---</option>
          <option>ch</option>
          <option>locode</option>
          <option>name</option>
          <option value="name_wo_diacritics">name without diacritics</option>
          <option value="sub_div">subdiv</option>
          <option>function</option>
          <option>status</option>
          <option>date</option>
          <option>iata</option>
          <option>lat</option>
          <option>lng</option>
          <option>remarks</option>
        </select>
        <input type="checkbox" id="order-desc" name="order-desc" />
        <label htmlFor="order-desc">Descending</label>
        <h3>Page</h3>
        <input type="text" placeholder="page number? defaults to 1" id="page" name="page" />
        <h3>Page Size</h3>
        <input type="text" placeholder="page size? defaults to 10" id="page-size" name="page-size" />
        <section>
          <button onClick={this.updateQueryVariables.bind(this)}>Update Query</button>
        </section>
        <h2>Find Nearest Hub</h2>
        <h3>To Address:</h3>
        <input type="text" placeholder="address" name="address" id="address" />
        <button id="find-by-address" onClick={this.findNearestHubToAddress.bind(this)}>Find</button>
        <h3>To Your Current Location:</h3>
        <button id="find-by-location" onClick={this.findNearestHubToUserLocation.bind(this)}>Find</button>
        <Query client={client} query={GET_HUBS} variables={this.state.queryVariables}>
          {({ loading, error, data }) => {
            if (loading) return <h1>Loading....</h1>
            if (error) return <h1 style={{ color: 'red' }}>Error loading hubs</h1>
            return (
              <Fragment>
                <h1>Query Results</h1>
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
                      <tr key={hub.id}>
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
                        <td>{(hub.lat && hub.lng && <a href={`https://www.google.com/maps/search/?api=1&query=${hub.lat},${hub.lng}`} target="_blank" rel="noopener noreferrer">View On Map</a>) || 'No map :('}</td>
                        <td>{hub.remarks}</td>
                      </tr >
                    ))}
                  </tbody >
                </table >
              </Fragment >
            );
          }}
        </Query >
      </Fragment >
    );
  }
}

export default App;
