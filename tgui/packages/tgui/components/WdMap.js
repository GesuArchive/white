import { Component } from 'inferno';
import { Box, Icon, Tooltip, Button } from '.';
import { resolveAsset } from '../assets';
import { useBackend } from "../backend";

const pauseEvent = e => {
  if (e.stopPropagation) { e.stopPropagation(); }
  if (e.preventDefault) { e.preventDefault(); }
  e.cancelBubble = true;
  e.returnValue = false;
  return false;
};

export class WdMap extends Component {
  constructor(props) {
    super(props);

    // Auto center based on window size
    const Xcenter = 0;
    const Ycenter = (window.innerHeight / 2) - 256;

    this.state = {
      offsetX: Xcenter,
      offsetY: Ycenter,
      transform: 'none',
      dragging: false,
      originX: null,
      originY: null,
    };

    // Dragging
    this.handleDragStart = e => {
      this.ref = e.target;
      this.setState({
        dragging: false,
        originX: e.screenX,
        originY: e.screenY,
      });
      document.addEventListener('mousemove', this.handleDragMove);
      document.addEventListener('mouseup', this.handleDragEnd);
      pauseEvent(e);
    };

    this.handleDragMove = e => {
      this.setState(prevState => {
        const state = { ...prevState };
        const newOffsetX = e.screenX - state.originX;
        const newOffsetY = e.screenY - state.originY;
        if (prevState.dragging) {
          state.offsetX += newOffsetX;
          state.offsetY += newOffsetY;
          state.originX = e.screenX;
          state.originY = e.screenY;
        } else {
          state.dragging = true;
        }
        return state;
      });
      pauseEvent(e);
    };

    this.handleDragEnd = e => {
      this.setState({
        dragging: false,
        originX: null,
        originY: null,
      });
      document.removeEventListener('mousemove', this.handleDragMove);
      document.removeEventListener('mouseup', this.handleDragEnd);
      pauseEvent(e);
    };

  }

  render() {
    const { dragging, offsetX, offsetY } = this.state;
    const { children } = this.props;
    const mapSize = (510) + 'px';
    const newStyle = {
      width: mapSize,
      height: mapSize,
      "margin-top": offsetY + "px",
      "margin-left": offsetX + "px",
      "overflow": "hidden",
      "position": "relative",
      "background-image": `url("${resolveAsset('boxstation_map.png')}")`,
      "background-size": "cover",
      "background-repeat": "no-repeat",
      "border": '1px solid rgba(0, 0, 0, .3)',
      "text-align": "center",
      "cursor": dragging ? "move" : "auto",
    };

    return (
      <Box className="WdMap__container">
        <Box
          style={newStyle}
          textAlign="center"
          onMouseDown={this.handleDragStart}>
          <Box>
            {children}
          </Box>
        </Box>
      </Box>
    );
  }
}

const WdMapMarker = props => {
  const {
    x,
    y,
    icon,
    tooltip,
    color,
  } = props;
  const rx = (x * 2) - 3;
  const ry = (y * 2) - 3;
  return (
    <div>
      <Box
        position="absolute"
        className="WdMap__marker"
        lineHeight="0"
        bottom={ry + "px"}
        left={rx + "px"}>
        <Icon
          name={icon}
          color={color}
          fontSize="6px"
        />
        <Tooltip content={tooltip} />
      </Box>
    </div>
  );
};

let ActiveButton;
class WdButton extends Component {
  constructor(props) {
    super(props);
    const { act } = useBackend(this.props.context);
    this.state = {
      color: this.props.color,
    };
    this.handleClick = e => {
      if (ActiveButton !== undefined) {
        ActiveButton.setState({
          color: "blue",
        });
      }
      act('switch_camera', {
        name: this.props.name,
      });
      ActiveButton = this;
      this.setState({
        color: "green",
      });
    };
  }
  render() {
    let rx = (this.props.x * 2) - 3;
    let ry = (this.props.y * 2) - 3;

    return (
      <Button
        key={this.props.key}
        // icon={this.props.icon}
        onClick={this.handleClick}
        position="absolute"
        className="WdMap__button"
        lineHeight="0"
        background-color={this.props.status ? this.state.color : "#ff0000"}
        bottom={ry + "px"}
        left={rx + "px"}
        tooltip={this.props.tooltip} />
    );
  }
}
WdMap.WdButton = WdButton;
WdMap.Marker = WdMapMarker;
