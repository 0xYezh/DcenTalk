mport React from 'react';
import { ethers } from 'ethers';
import { Button, Container } from 'react-bootstrap';
import './App.css';

const CONTRACT_ABI = require('./DcenTalk.json/ABIjson.json');

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
        maskNetworkHandle: '',  // state to hold user's input for Mask Network Handle
        nextIDHandle: '',      // state to hold user's input for NextID
    };
    this.handleMaskInputChange = this.handleMaskInputChange.bind(this);
    this.handleNextIDInputChange = this.handleNextIDInputChange.bind(this);
    this.connectMask = this.connectMask.bind(this);
    this.connectNextID = this.connectNextID.bind(this);
    this.scheduleWithLink = this.scheduleWithLink.bind(this);
}

handleMaskInputChange(event) {
    this.setState({ maskNetworkHandle: event.target.value });
}

handleNextIDInputChange(event) {
    this.setState({ nextIDHandle: event.target.value });
}

componentDidMount() {
  this.initializeEthereum();
}

async connectMask() {
    const maskHandle = this.state.maskNetworkHandle;
    try {
      const tx = await this.contract.registerUser(maskHandle);
      const receipt = await tx.wait();
      console.log('User registered:', receipt);
  } catch (error) {
      console.error("Error registering user:", error);
  }
}

async connectNextID() {
  const nextID = this.state.nextIDHandle;
  try {
      const tx = await this.contract.linkNextID(nextID);
      const receipt = await tx.wait();
      console.log('NextID linked:', receipt);
  } catch (error) {
      console.error("Error linking NextID:", error);
  }
}

async scheduleWithLink() {
  try {
      const worldClockTime = Date.now();
      const tx = await this.contract.updateUserWorldClockTime(worldClockTime);
      const receipt = await tx.wait();
      console.log('World Clock Time updated:', receipt);
  } catch (error) {
      console.error("Error updating World Clock Time:", error);
  }
}

  render() {
    return (
      <Container className="container">
        <Button variant="primary" size="lg" onClick={this.connectMask}>
          Login Mask
        </Button>
        <Button variant="primary" size="lg" onClick={this.connectNextID}>
          Connect NextID
        </Button>
        <Button variant="success" size="lg" onClick={this.scheduleWithLink}>
          Schedule with Link
        </Button>
      </Container>
    );
  }
}

export default App;
