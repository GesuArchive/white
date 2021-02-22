/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { canRender, classes } from 'common/react';
import { Component, createRef, InfernoNode, RefObject } from 'inferno';
import { addScrollableNode, removeScrollableNode } from '../events';
import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';

interface SectionProps extends BoxProps {
  className?: string;
  title?: string;
  buttons?: InfernoNode;
  fill?: boolean;
  fitted?: boolean;
  scrollable?: boolean;
  /** @deprecated This property no longer works, please remove it. */
  level?: boolean;
  /** @deprecated Please use `scrollable` property */
  overflowY?: any;
}

export class Section extends Component<SectionProps> {
  scrollableRef: RefObject<HTMLDivElement>;
  scrollable: boolean;

  constructor(props) {
    super(props);
    this.ref = createRef();
    this.scrollable = props.scrollable;
  }

  componentDidMount() {
    if (this.scrollable) {
      addScrollableNode(this.ref.current);
    }
  }

  componentWillUnmount() {
    if (this.scrollable) {
      removeScrollableNode(this.ref.current);
    }
  }

  render() {
    const {
      className,
      title,
      level = 1,
      buttons,
      fill,
      fitted,
      scrollable,
      children,
      ...rest
    } = this.props;
    const hasTitle = canRender(title) || canRender(buttons);
    const content = fitted
      ? children
      : (
        <div
          ref={this.ref}
          className="Section__content">
          {children}
        </div>
      );
    return (
      <div
        ref={fitted ? this.ref : undefined}
        className={classes([
          'Section',
          'Section--level--' + level,
          Byond.IS_LTE_IE8 && 'Section--iefix',
          fill && 'Section--fill',
          fitted && 'Section--fitted',
          scrollable && 'Section--scrollable',
          className,
          computeBoxClassName(rest),
        ])}
        {...computeBoxProps(rest)}>
        {hasTitle && (
          <div className="Section__title">
            <span className="Section__titleText">
              {title}
            </span>
            <div className="Section__buttons">
              {buttons}
            </div>
          </div>
        )}
        <div className="Section__rest">
          {content}
        </div>
      </div>
    );
  }
}
