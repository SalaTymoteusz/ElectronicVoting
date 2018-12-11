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
                <img src="https://i.pinimg.com/originals/e8/57/a8/e857a8a9535fa7ceb5a749cc55bf4e78.png" alt="Girl in a jacket" width="200" height="300"/> 
                <img src="https://data1.cupsell.pl/upload/generator/15375/640x420/236093_print-trimmed-2.png" alt="Girl in a jacket" width="200" height="200"/>
                <img src="https://s.tcdn.co/e42/290/e4229014-8f04-3acb-b09c-1a3dafc9d1ef/5.png" alt="Girl in a jacket" width="200" height="200"/> 
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