import React from 'react';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

import { userActions } from '../_actions';

class HomePage extends React.Component {
    componentDidMount() {
        this.props.dispatch(userActions.getAll());
    }

    handleDeleteUser(id) {
        return (e) => this.props.dispatch(userActions.delete(id));
    }

    render() {
        const { user, users } = this.props;
        return (
            <div className="col-md-6 col-md-offset-3">
                <h1>Cześć {user.firstName}!</h1>
                    <pre>
                              ∩＿＿＿∩ <br/> 
                             |ノ      ヽ<br/> 
                            /   ●    ● | クマ──！！<br/> 
                           |     (_●_) ミ<br/> 
                          彡､     |∪|  ､｀＼<br/> 
                        / ＿＿    ヽノ /´>   )<br/> 
                        (＿＿＿）     /  (_／<br/> 
                          |        /<br/> 
                          |   ／＼  ＼<br/> 
                          | /     )   )<br/> 
                           ∪     （   ＼<br/> 
                                   ＼＿)
                    </pre>
                <p>You're logged in with React!!! :)</p>
                <h3>Wszyscy zarejestrowani użytkownicy:</h3>
                {users.loading && <em>Loading users...</em>}
                {users.error && <span className="text-danger">ERROR: {users.error}</span>}
                {users.items &&
                    <ul>
                        {users.items.map((user, index) =>
                            <li key={user.id}>
                                {user.firstName + ' ' + user.lastName 
                                                 + '(' + user.username + ')'}
                                {
                                    user.deleting ? <em> - Deleting...</em>
                                    : user.deleteError ? <span className="text-danger"> - ERROR: {user.deleteError}</span>
                                    : <span> - <a onClick={this.handleDeleteUser(user.id)}>Usuń</a></span>
                                }
                            </li>
                        )}
                    </ul>
                }
                <p>
                    <Link to="/login">Wyloguj</Link>
                </p>
            </div>
        );
    }
}

function mapStateToProps(state) {
    const { users, authentication } = state;
    const { user } = authentication;
    return {
        user,
        users
    };
}

const connectedHomePage = connect(mapStateToProps)(HomePage);
export { connectedHomePage as HomePage };